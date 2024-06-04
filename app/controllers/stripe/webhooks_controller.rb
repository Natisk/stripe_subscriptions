# frozen_string_literal: true

class Stripe::WebhooksController < ApplicationController
  skip_forgery_protection

  def create
    endpoint_secret = Rails.application.credentials.stripe[:endpoint_secret]
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      status 400
      return
    end

    # Handle the event
    case event.type
    # when 'customer.subscription.created'
      # debugger
      # Stripe::CreateSubscriptionService.call(event.data.object)
    when 'customer.subscription.deleted'
      p '--- subscription canceled ---'
    when 'invoice.paid'
      debugger
      # Stripe::CreateInvoiceService.call(event.data.object)
      p '--- subscription paid ---'
    else
      puts "--------------- Unhandled event type: #{event.type} ---------------------"
    end

    status 200
  end
end
