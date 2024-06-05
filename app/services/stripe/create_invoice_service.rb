# frozen_string_literal: true

class Stripe::CreateInvoiceService < BaseService
  attr_reader :stripe_invoice

  def initialize(stripe_invoice)
    @stripe_invoice = stripe_invoice
  end

  def call
    subscription = Subscription.find_by(stripe_subscription_id: stripe_invoice.subscription)

    subscription.invoices.create!(
      stripe_customer_id: stripe_invoice.customer,
      stripe_subscription_id: stripe_invoice.subscription,
      account_country: stripe_invoice.account_country,
      amount_due: stripe_invoice.amount_due,
      amount_paid: stripe_invoice.amount_paid,
      amount_remaining: stripe_invoice.amount_remaining,
      amount_shipping: stripe_invoice.amount_shipping,
      billing: stripe_invoice.billing,
      charge: stripe_invoice.charge,
      currency: stripe_invoice.currency,
      paid: stripe_invoice.paid,
      status: stripe_invoice.status
    )

    subscription.pay!
  end
end
