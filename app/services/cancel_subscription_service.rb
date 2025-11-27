# frozen_string_literal: true

# Service to cancel Subscriptions
class CancelSubscriptionService < BaseService
  def initialize(subscription_id) # rubocop:disable Lint/MissingSuper
    @subscription_id = subscription_id
  end

  def call
    subscription = Subscription.find_by!(stripe_subscription_id: subscription_id)
    # AASM handles state transitions
    subscription.cancel!
  end

  private

  attr_reader :subscription_id
end
