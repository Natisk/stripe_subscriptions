# frozen_string_literal: true

class Stripe::EventsHandlerService < BaseService
  def initialize(event)
    @event = event
  end

  def call
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
  end

  private

  attr_reader :event
end
