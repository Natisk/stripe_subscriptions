# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stripe::VerifyWebhookSignatureService do
  subject(:service) { described_class.new(request).call }

  let(:request) { instance_double(ActionDispatch::Request) }
  let(:secret) { 'whsec_test' }
  let(:payload) { '{ "id": "evt_123" }' }
  let(:signature) { 't=12345,v1=testsignature' }

  before do
    allow(ENV).to receive(:[]).with('STRIPE_WEBHOOK_SECRET').and_return(secret)
    allow(request).to receive(:raw_post).and_return(payload)
    allow(request).to receive(:env).and_return('HTTP_STRIPE_SIGNATURE' => signature)
  end

  describe '#call' do
    context 'when request is nil' do
      let(:request) { nil }

      it 'returns nil and logs warning' do
        expect(Rails.logger).to receive(:warn).with('Stripe VerifyWebhookSignatureService: No request provided to Service')
        expect(service).to be_nil
      end
    end

    context 'when secret is missing' do
      let(:secret) { nil }

      it 'returns nil and logs warning' do
        expect(Rails.logger).to receive(:warn).with('Stripe VerifyWebhookSignatureService: Stripe webhook secret not configured')
        expect(service).to be_nil
      end
    end

    context 'when Stripe-Signature header is missing' do
      before do
        allow(request).to receive(:env).and_return({})
      end

      it 'returns nil and logs warning' do
        expect(Rails.logger).to receive(:warn).with('Stripe VerifyWebhookSignatureService: Missing Stripe-Signature header')
        expect(service).to be_nil
      end
    end

    context 'when payload is invalid JSON' do
      before do
        allow(request).to receive(:raw_post).and_return('invalid_json')
        allow(::Stripe::Webhook).to receive(:construct_event)
          .and_raise(JSON::ParserError.new('unexpected token'))
      end

      it 'returns nil and logs error' do
        expect(Rails.logger).to receive(:error).with(/Stripe webhook JSON parse error/)
        expect(service).to be_nil
      end
    end

    context 'when Stripe signature verification fails' do
      before do
        allow(::Stripe::Webhook).to receive(:construct_event)
          .and_raise(::Stripe::SignatureVerificationError.new('bad sig', 'sig_header'))
      end

      it 'returns nil and logs warning' do
        expect(Rails.logger).to receive(:warn).with(/Stripe webhook signature verification failed/)
        expect(service).to be_nil
      end
    end

    context 'when unexpected error occurs' do
      before do
        allow(::Stripe::Webhook).to receive(:construct_event)
          .and_raise(StandardError.new('boom'))
      end

      it 'returns nil and logs error with backtrace' do
        expect(Rails.logger).to receive(:error).with(/Unexpected error verifying Stripe webhook/)
        expect(Rails.logger).to receive(:error).at_least(:once)
        expect(service).to be_nil
      end
    end

    context 'when verification succeeds' do
      let(:event) { instance_double(::Stripe::Event) }

      before do
        allow(::Stripe::Webhook).to receive(:construct_event)
          .with(payload, signature, secret)
          .and_return(event)
      end

      it 'returns the verified event' do
        expect(service).to eq(event)
      end
    end
  end
end
