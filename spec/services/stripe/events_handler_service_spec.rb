# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stripe::EventsHandlerService do
  let(:event) { double('Stripe::Event', type: event_type, data: data) }
  let(:object) { instance_double('Stripe::Object') }
  let(:data)   { instance_double('Stripe::Event::Data', object: object) }

  subject { described_class.new(event) }

  describe '#call' do
    context 'when event type is customer.subscription.created' do
      let(:event_type) { 'customer.subscription.created' }
      let(:mapped)     { { external_id: 'sub_123' } }

      before do
        mapper = instance_double(Stripe::SubscriptionMapper, call: mapped)
        allow(Stripe::SubscriptionMapper).to receive(:new).with(object).and_return(mapper)
      end

      it 'calls CreateSubscriptionService with mapped params' do
        expect(CreateSubscriptionService).to receive(:call).with(mapped)
        subject.call
      end

      it 're-raises errors from handler' do
        allow(CreateSubscriptionService).to receive(:call).and_raise(StandardError.new('boom'))
        expect { subject.call }.to raise_error(StandardError)
      end
    end

    context 'when event type is customer.subscription.deleted' do
      let(:event_type) { 'customer.subscription.deleted' }

      before do
        allow(object).to receive(:id).and_return('sub_123')
      end

      it 'calls CancelSubscriptionService with subscription id' do
        expect(CancelSubscriptionService).to receive(:call).with('sub_123')
        subject.call
      end
    end

    context 'when event type is invoice.paid' do
      let(:event_type) { 'invoice.paid' }
      let(:mapped)     { { external_id: 'sub_123' } }

      before do
        mapper = instance_double(Stripe::InvoiceMapper, call: mapped)
        allow(Stripe::InvoiceMapper).to receive(:new).with(object).and_return(mapper)
      end

      it 'calls CreateInvoiceService with mapped params' do
        expect(CreateInvoiceService).to receive(:call).with(mapped)
        subject.call
      end
    end

    context 'when event type is unhandled' do
      let(:event_type) { 'some.unknown.event' }

      it 'logs a warning' do
        expect(Rails.logger).to receive(:warn).with('Unhandled Stripe event type: some.unknown.event')
        subject.call
      end
    end
  end
end
