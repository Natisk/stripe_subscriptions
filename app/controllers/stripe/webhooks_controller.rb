# frozen_string_literal: true

class Stripe::WebhooksController < ApplicationController
  skip_forgery_protection

  def create
    event = verify_stripe_signature
    return unless event

    Stripe::EventsHandlerService.call(event)

    head :ok
  end

  private

  def verify_stripe_signature
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    return render(json: { error: 'Missing webhook secret' }, status: :bad_request) if endpoint_secret.blank?

    payload = request.raw_post
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
  rescue JSON::ParserError => e
    Rails.logger.error("Stripe webhook JSON parse error: #{e.message}")
    render json: { error: e.message }, status: :bad_request
    nil
  rescue Stripe::SignatureVerificationError => e
    Rails.logger.error("Stripe webhook signature error: #{e.message}")
    render json: { error: e.message }, status: :bad_request
    nil
  end
end
