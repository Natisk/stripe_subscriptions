# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stripe::EventsHandlerService do
  describe '#call' do
    let(:event) { double('Stripe::Event') }
    let(:object) { double('EventDataObject') }
    let(:data_origin) { :stripe }

    before do
      allow(event).to receive(:data).and_return(double(object: object))
    end

    subject { described_class.new(event) }

    context 'when event type is customer.subscription.created' do
      it 'calls CreateSubscriptionService with the event object and :stripe' do
        allow(event).to receive(:type).and_return('customer.subscription.created')
        expect(CreateSubscriptionService).to receive(:call).with(object, data_origin)
        subject.call
      end
    end

    context 'when event type is customer.subscription.deleted' do
      it 'calls CancelSubscriptionService with the event object and :stripe' do
        allow(event).to receive(:type).and_return('customer.subscription.deleted')
        expect(CancelSubscriptionService).to receive(:call).with(object, data_origin)
        subject.call
      end
    end

    context 'when event type is invoice.paid' do
      it 'calls CreateInvoiceService with the event object and :stripe' do
        allow(event).to receive(:type).and_return('invoice.paid')
        expect(CreateInvoiceService).to receive(:call).with(object, data_origin)
        subject.call
      end
    end

    context 'when event type is unhandled' do
      it 'prints an unhandled event type message' do
        allow(event).to receive(:type).and_return('unhandled.event')
        expect { subject.call }.to output("---- Unhandled event type: unhandled.event ----\n").to_stdout
      end
    end
  end
end
