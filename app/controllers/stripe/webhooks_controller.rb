# frozen_string_literal: true

module Stripe
  # Webhook controller
  class WebhooksController < ApplicationController
    skip_forgery_protection

    def create
      event = Stripe::VerifyWebhookSignatureService.call(request)
      return head :bad_request unless event

      Stripe::ProcessWebhookEventService.call(event)

      head :ok
    rescue => e # rubocop:disable Style/RescueStandardError
      Rails.logger.error("Stripe webhook processing error: #{e.class} - #{e.message}")
      head :internal_server_error
    end
  end
end
