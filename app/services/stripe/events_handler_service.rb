# frozen_string_literal: true

class Stripe::EventsHandlerService < BaseService
  def initialize(event)
    @event = event
  end

  def call
    case event.type

    when 'customer.subscription.created'
      handle_subscribtion_created

    when 'customer.subscription.deleted'
      CancelSubscriptionService.call(event.data.object, :stripe)

    when 'invoice.paid'
      CreateInvoiceService.call(event.data.object, :stripe)

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
  rescue => e
    Rails.logger.error("Failed to handle subscribtion created #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    raise
  end

end
