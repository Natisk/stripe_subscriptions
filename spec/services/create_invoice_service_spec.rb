# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateInvoiceService do
  describe '#call' do
    let(:invoice_params) { double("InvoiceParams", subscription: 'sub_123') }    
    let(:subscription) { instance_double(Subscription, id: 1, stripe_subscription_id: 'sub_123') }
    let(:mapped_params) { { amount: 1000, currency: 'usd' } }
    let(:invoice) { instance_double(Invoice) }

    context 'stripe origin' do
      let(:data_origin) { :stripe }
      let(:stripe_invoice_mapper) { instance_double(Stripe::InvoiceMapper, call: mapped_params) }

      subject { described_class.new(invoice_params, data_origin) }

      before do
        allow(Stripe::InvoiceMapper).to receive(:new).with(invoice_params).and_return(stripe_invoice_mapper)
        allow(Subscription).to receive(:find_by!).with({ stripe_subscription_id: 'sub_123' })
                                                 .and_return(subscription)
        allow(subscription).to receive(:invoices).and_return(double(create!: invoice))
        allow(subscription).to receive(:pay!)
      end

      it 'calls stripe_incvoice_mapper' do
        expect(stripe_invoice_mapper).to receive(:call)
        subject.call
      end

      it 'finds the subscription' do
        expect(Subscription).to receive(:find_by!).with({ stripe_subscription_id: 'sub_123' })
                                                  .and_return(subscription)
        subject.call
      end

      it 'calls create an invoice for the subscription' do
        expect(subscription.invoices).to receive(:create!).with(mapped_params)
        subject.call
      end

      it 'calls pay! on the subscription' do
        expect(subscription).to receive(:pay!)
        subject.call
      end
    end
  end
end
