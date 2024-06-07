# frozen_string_literal: true

class Stripe::WebhooksController < ApplicationController
  skip_forgery_protection

  def create
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { error: e.message }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { error: e.message }, status: :bad_request
      return
    end

    Stripe::EventsHandlerService.call(event)

    head 200
  end
end
