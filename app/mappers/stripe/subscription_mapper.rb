# frozen_string_literal: true

class Stripe::SubscriptionMapper
  def initialize(subcription_params)
    @subcription_params = subcription_params
  end

  def call
    {
      stripe_customer_id: subcription_params.customer,
      stripe_subscription_id: subcription_params.id
    }
  end

  private

  attr_reader :subcription_params
end
