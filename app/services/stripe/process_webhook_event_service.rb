# frozen_string_literal: true

module Stripe
  # Process Stripe Webhooks
  class ProcessWebhookEventService < BaseService
    def initialize(event) # rubocop:disable Lint/MissingSuper
      @event = event
    end

    def call
      return if processed?

      log_event!

      Stripe::EventsHandlerService.call(event)
    end

    private

    attr_reader :event

    def processed?
      StripeEventLog.exists?(event_id: event.id)
    end

    def log_event!
      StripeEventLog.create!(event_id: event.id)
    end
  end
end
