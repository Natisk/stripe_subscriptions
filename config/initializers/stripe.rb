# frozen_string_literal: true

Stripe.api_key = Rails.env.test? ? '' : Rails.application.credentials.stripe[:api_key]
