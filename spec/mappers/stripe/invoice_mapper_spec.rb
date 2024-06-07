# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stripe::InvoiceMapper do
  describe '#call' do
    let(:invoice_params) do
      double('InvoiceParams', {
        customer: 'cus_123',
        subscription: 'sub_123',
        account_country: 'US',
        amount_due: 1000,
        amount_paid: 900,
        amount_remaining: 100,
        amount_shipping: 50,
        charge: 'ch_123',
        currency: 'usd',
        paid: true,
        status: 'paid'
      })
    end

    subject { described_class.new(invoice_params) }

    it 'maps the invoice parameters' do
      expected_params = {
        stripe_customer_id: 'cus_123',
        stripe_subscription_id: 'sub_123',
        account_country: 'US',
        amount_due: 1000,
        amount_paid: 900,
        amount_remaining: 100,
        amount_shipping: 50,
        charge: 'ch_123',
        currency: 'usd',
        paid: true,
        status: 'paid'
      }

      expect(subject.call).to eq(expected_params)
    end
  end
end
