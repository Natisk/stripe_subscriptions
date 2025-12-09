# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stripe::WebhooksController, type: :controller do
  describe 'POST #create' do
    let(:event) { instance_double('Stripe::Event') }

    before do
      allow(Stripe::VerifyWebhookSignatureService).to receive(:call).and_return(event)
      allow(Stripe::ProcessWebhookEventService).to receive(:call)
    end

    context 'when signature verification succeeds' do
      it 'processes the event and returns :ok' do
        post :create

        expect(Stripe::VerifyWebhookSignatureService).to have_received(:call)
        expect(Stripe::ProcessWebhookEventService).to have_received(:call).with(event)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when signature verification fails' do
      before do
        allow(Stripe::VerifyWebhookSignatureService).to receive(:call).and_return(nil)
      end

      it 'returns :bad_request and doesnt call ProcessWebhookEventService' do
        post :create

        expect(Stripe::ProcessWebhookEventService).not_to have_received(:call)
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
