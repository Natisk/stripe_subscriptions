# frozen_string_literal: true

if Rails.application.credentials.stripe
  Stripe.api_key = Rails.env.test? ? '' : Rails.application.credentials.stripe[:api_key]
end
