# frozen_string_literal: true

module Stripe
  # Handles Stripe events
  class EventsHandlerService < BaseService
    def initialize(event) # rubocop:disable Lint/MissingSuper
      @event = event
    end

    def call
      case event.type

      when 'customer.subscription.created'
        handle_subscription_created
      when 'customer.subscription.deleted'
        handle_subscription_deleted
      when 'invoice.paid'
        handle_invoice_paid
      else
        # Helpful for debugging unexpected or newly introduced Stripe events.
        Rails.logger.warn "Unhandled Stripe event type: #{event.type}"
      end
    end

    private

    attr_reader :event

    def handle_subscription_created
      handle_event('subscription created') do
        mapped = Stripe::SubscriptionMapper.new(event.data.object).call
        CreateSubscriptionService.call(mapped)
      end
    end

    def handle_subscription_deleted
      handle_event('subscription_deleted') do
        subscription_id = event.data.object.id
        CancelSubscriptionService.call(subscription_id)
      end
    end

    def handle_invoice_paid
      handle_event('invoice_paid') do
        mapped = Stripe::InvoiceMapper.new(event.data.object).call
        CreateInvoiceService.call(mapped)
      end
    end

    def handle_event(label)
      yield
    rescue StandardError => e
      Rails.logger.error("Failed to handle #{label} #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      raise # re-raise so Stripe retries the webhook
    end
  end
end
