# frozen_string_literal: true

if ENV['STRIPE_API_KEY']
  Stripe.api_key = Rails.env.production? ? '' : ENV['STRIPE_API_KEY']
end
