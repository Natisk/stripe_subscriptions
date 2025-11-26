# frozen_string_literal: true

class CreateInvoiceService < BaseService
  # Mapping between data origins and corresponding mappers.
  # This makes the service extensible if more providers appear in the future.
  MAPPERS = {
    stripe: Stripe::InvoiceMapper
  }.freeze

  def initialize(invoice_params, data_origin)
    @invoice_params = invoice_params
    @data_origin = data_origin
  end

  def call
    # Select appropriate mapper based on the data origin.
    # Fail fast if the origin is not supported to avoid silent incorrect processing.
    mapper = MAPPERS[data_origin]
    raise ArgumentError, "Unknown data_origin: #{data_origin}" unless mapper

    # Convert incoming webhook payload into application-specific invoice parameters.
    mapped_params = mapper.new(invoice_params).call

    # Locate the corresponding Subscription in the system using values from the webhook.
    # Raises ActiveRecord::RecordNotFound if the subscription does not exist,
    # which will trigger a retry from Stripe.
    subscription = Subscription.find_by!(params_to_find)

    # Creates a new Invoice associated with the subscription.
    # The bang (!) ensures validation errors are not swallowed.
    subscription.invoices.create!(mapped_params)

    # Trigger subscription state transition (handled by AASM in the Subscription model).
    # If something goes wrong here, the error will propagate and Stripe will retry the webhook.
    subscription.pay!
  rescue => e
    # Log the error for debugging and observability.
    # Re-raising the error ensures Stripe retries the webhook instead of silently ignoring the failure.
    Rails.logger.error("CreateInvoiceService error: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    raise
  end

  private

  attr_reader :invoice_params, :data_origin

  # Build a lookup hash to find the correct Subscription record.
  # For Stripe, this uses the subscription ID provided inside the invoice payload.
  # If Stripe expands the subscription object, we handle both string and hash formats.
  def params_to_find
    case data_origin
    when :stripe
      sub = invoice_params.subscription
      id = sub.is_a?(String) ? sub : sub&.dig("id")
      { stripe_subscription_id: id }
    end
  end
end
