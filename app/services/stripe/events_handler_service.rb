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
        handle_subscribtion_created
      when 'customer.subscription.deleted'
        handle_subscription_deleted
      when 'invoice.paid'
        handle_invoice_paid
      else
        # Helpful for debugging unexpected or newly introduced Stripe events.
        Rails.logger.info "Unhandled Stripe event type: #{event.type}"
      end
    end

    private

    attr_reader :event

    def handle_subscribtion_created
      mapped = Stripe::SubscriptionMapper.new(event.data.object).call
      CreateSubscriptionService.call(mapped)
    rescue => e # rubocop:disable Style/RescueStandardError
      Rails.logger.error("Failed to handle subscribtion created #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      raise
    end

    def handle_subscription_deleted
      subscription_id = event.data.object.id
      CancelSubscriptionService.call(subscription_id)
    rescue => e # rubocop:disable Style/RescueStandardError
      Rails.logger.error("Failed to handle subscription deleted #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      raise
    end

    def handle_invoice_paid
      mapped = Stripe::InvoiceMapper.new(event.data.object).call
      CreateInvoiceService.call(mapped)
    rescue => e # rubocop:disable Style/RescueStandardError
      Rails.logger.error("Failed to handle invoice paid #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      raise
    end
  end
end
