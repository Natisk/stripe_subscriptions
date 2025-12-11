# frozen_string_literal: true

module Stripe
  # Verify webhooks signatures
  class VerifyWebhookSignatureService < BaseService
    def initialize(request) # rubocop:disable Lint/MissingSuper
      @request = request
    end

    def call
      return log_and_nil('No request provided to Service') unless request

      secret = ENV['STRIPE_WEBHOOK_SECRET']
      return log_and_nil('Stripe webhook secret not configured') if secret.blank?

      payload = request.raw_post
      signature = request.env['HTTP_STRIPE_SIGNATURE']

      return log_and_nil('Missing Stripe-Signature header') if signature.blank?

      ::Stripe::Webhook.construct_event(payload, signature, secret)
    rescue JSON::ParserError => e
      Rails.logger.error("Stripe webhook JSON parse error: #{e.message}")
      nil
    rescue ::Stripe::SignatureVerificationError => e
      Rails.logger.warn("Stripe webhook signature verification failed: #{e.message}")
      nil
    rescue => e # rubocop:disable Style/RescueStandardError
      Rails.logger.error("Unexpected error verifying Stripe webhook: #{e.class} - #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      nil
    end

    private

    attr_reader :request

    def log_and_nil(message)
      Rails.logger.warn("Stripe VerifyWebhookSignatureService: #{message}")
      nil
    end
  end
end
