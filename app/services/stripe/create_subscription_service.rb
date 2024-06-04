# frozen_string_literal: true

class Stripe::CreateSubscriptionService < BaseService
  attr_reader :stripe_subscription

  def initialize(stripe_subscription)
    @stripe_subscription = stripe_subscription
  end

  def call
    Subscription.create(stripe_customer_id: stripe_subscription.customer,
                        stripe_subscription_id: stripe_subscription.id)
  end
end
