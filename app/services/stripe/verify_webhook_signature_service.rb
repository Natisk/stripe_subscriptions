# frozen_string_literal: true

module Stripe
  # Verify webhooks signatures
  class VerifyWebhookSignatureService < BaseService
    def initialize(request) # rubocop:disable Lint/MissingSuper
      @request = request
    end

    def call
      secret = ENV['STRIPE_WEBHOOK_SECRET']

      if secret.blank?
        Rails.logger.warn('Stripe webhook secret not configured (STRIPE_WEBHOOK_SECRET).')
        return nil
      end

      unless request
        Rails.logger.warn('No request provided to VerifyWebhookSignatureService')
        return nil
      end

      payload = begin
        request.raw_post
      rescue => e
        Rails.logger.warn("Failed to read request body: #{e.message}")
        return nil
      end

      signature = request.env['HTTP_STRIPE_SIGNATURE']

      unless signature.present?
        Rails.logger.warn('Stripe signature header missing (HTTP_STRIPE_SIGNATURE).')
        return nil
      end

      ::Stripe::Webhook.construct_event(payload, signature, secret)
    rescue JSON::ParserError, ::Stripe::SignatureVerificationError => e
      Rails.logger.warn("Stripe signature error: #{e.message}")
      nil
    end

    private

    attr_reader :request
  end
end
