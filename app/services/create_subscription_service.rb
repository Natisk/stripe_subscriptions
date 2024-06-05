# frozen_string_literal: true

class CreateSubscriptionService < BaseService
  def initialize(subscription_params, data_origin)
    @subscription_params = subscription_params
    @data_origin = data_origin
  end

  def call
    mapped_params = case data_origin
                    when :stripe
                      StripeSubscriptionMapper.new(subscription_params).call
                    end

    Subscription.create!(mapped_params)
  end

  private

  attr_reader :subscription_params, :data_origin
end
