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
      return head 400
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      return head 400
    end

    # Handle the event
    case event.type
    when 'customer.subscription.created'
      # debugger
      Stripe::CreateSubscriptionService.call(event.data.object)
      p '--- subscription created ---'
    # when 'subscription_schedule.created'
      # debugger
      # Stripe::CreateSubscriptionService.call(event.data.object)
    when 'customer.subscription.deleted'
      p '--- subscription canceled ---'
    when 'invoice.paid'
      # debugger
      Stripe::CreateInvoiceService.call(event.data.object)
      p '--- subscription paid ---'
    else
      puts "--------------- Unhandled event type: #{event.type} ---------------------"
    end

    head 200
  end
end
