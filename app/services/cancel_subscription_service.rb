# frozen_string_literal: true

class CancelSubscriptionService < BaseService
  def initialize(subscription_params, data_origin)
    @subscription_params = subscription_params
    @data_origin = data_origin
  end

  def call
    subscription = Subscription.find_by!(params_to_find)
    subscription.cancel!
  end

  private

  attr_reader :subscription_params, :data_origin

  def params_to_find
    case data_origin
    when :stripe
      { stripe_subscription_id: subscription_params.id }
    end
  end
end
