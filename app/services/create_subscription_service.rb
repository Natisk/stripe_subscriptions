# frozen_string_literal: true

# Service to create Subscribtions
class CreateSubscriptionService < BaseService
  def initialize(subscription_params) # rubocop:disable Lint/MissingSuper
    @subscription_params = subscription_params
  end

  def call
    Subscription.create!(subscription_params)
  end

  private

  attr_reader :subscription_params
end
