# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stripe::EventsHandlerService do
  describe '#call' do
    let(:event) { double('Stripe::Event') }
    let(:object) { double('EventDataObject') }

    before do
      allow(event).to receive(:data).and_return(double(object: object))
    end

    subject { described_class.new(event) }

    context 'when event type is customer.subscription.created' do
      it 'calls CreateSubscriptionService with the event object' do
        allow(event).to receive(:type).and_return('customer.subscription.created')
        expect(CreateSubscriptionService).to receive(:call).with(object, data_origin)
        subject.call
      end
    end

    context 'when event type is customer.subscription.deleted' do
      it 'calls CancelSubscriptionService with the event object' do
        allow(event).to receive(:type).and_return('customer.subscription.deleted')
        expect(CancelSubscriptionService).to receive(:call).with(object)
        subject.call
      end
    end

    context 'when event type is invoice.paid' do
      it 'calls CreateInvoiceService with the event object' do
        allow(event).to receive(:type).and_return('invoice.paid')
        expect(CreateInvoiceService).to receive(:call).with(object)
        subject.call
      end
    end

    context 'when event type is unhandled' do
      it 'logs an info message' do
        allow(event).to receive(:type).and_return('unhandled.event')
        expect(Rails.logger).to receive(:info).with('Unhandled Stripe event type: unhandled.event')
        subject.call
      end
    end
  end
end
