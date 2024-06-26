# frozen_string_literal: true

class Stripe::EventsHandlerService < BaseService
  def initialize(event)
    @event = event
  end

  def call
    case event.type
    when 'customer.subscription.created'
      CreateSubscriptionService.call(event.data.object, :stripe)
    when 'customer.subscription.deleted'
      CancelSubscriptionService.call(event.data.object, :stripe)
    when 'invoice.paid'
      CreateInvoiceService.call(event.data.object, :stripe)
    else
      puts "---- Unhandled event type: #{event.type} ----"
    end
  end

  private

  attr_reader :event
end
