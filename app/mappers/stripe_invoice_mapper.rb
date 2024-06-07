# frozen_string_literal: true

class StripeInvoiceMapper
  def initialize(invoice_params)
    @invoice_params = invoice_params
  end

  def call
    {
      stripe_customer_id: invoice_params.customer,
      stripe_subscription_id: invoice_params.subscription,
      account_country: invoice_params.account_country,
      amount_due: invoice_params.amount_due,
      amount_paid: invoice_params.amount_paid,
      amount_remaining: invoice_params.amount_remaining,
      amount_shipping: invoice_params.amount_shipping,
      charge: invoice_params.charge,
      currency: invoice_params.currency,
      paid: invoice_params.paid,
      status: invoice_params.status
    }
  end

  private

  attr_reader :invoice_params
end
