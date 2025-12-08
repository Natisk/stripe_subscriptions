# frozen_string_literal: true

module Stripe
  # Verify webhooks signatures
  class VerifyWebhoodSignatureService < BaseService
    def initilize(request)
      @request = request
    end

    def call
      secret = ENV['STRIPE_WEBHOOK_SECRET']

      return nil if secret.blank?

      payload = request.raw_post
      signature = request.env['HTTP_STRIPE_SIGNATURE']

      ::Stripe::Webhook.construct_event(payload, signature, secret)
    rescue JSON::ParserError, ::Stripe::SignatureVerificationError => e
      Rails.logger.warn("Stripe signature error: #{e.message}")
      nil
    end

    private

    attr_reader :request
  end
end
