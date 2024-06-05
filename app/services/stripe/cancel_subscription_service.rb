# frozen_string_literal: true

class Stripe::CancelSubscriptionService < BaseService
  attr_reader :stripe_subscription

  def initialize(stripe_subscription)
    @stripe_subscription = stripe_subscription
  end

  def call
    subscription = Subscription.find_by!(stripe_subscription_id: stripe_subscription.id)
    subscription.cancel!
  end
end
