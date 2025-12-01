# frozen_string_literal: true

module Stripe
  # Stripe Subscriptions Mapper
  class SubscriptionMapper
    def initialize(subcription_params)
      @subcription_params = subcription_params
    end

    def call
      {
        customer_id: subcription_params.customer,
        external_id: subcription_params.id
      }
    end

    private

    attr_reader :subcription_params
  end
end
