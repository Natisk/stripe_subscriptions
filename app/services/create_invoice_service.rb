# frozen_string_literal: true

# Service to create Subscription Invoices
class CreateInvoiceService < BaseService
  def initialize(mapped_params) # rubocop:disable Lint/MissingSuper
    @mapped_params = mapped_params
  end

  def call
    # Locate the corresponding Subscription in the system using values from the webhook.
    # Raises ActiveRecord::RecordNotFound if the subscription does not exist,
    # which will trigger a retry from Stripe.
    subscription = Subscription.find_by!(stripe_subscription_id: mapped_params[:subscription_id])

    # Creates a new Invoice associated with the subscription.
    # The bang (!) ensures validation errors are not swallowed.
    subscription.invoices.create!(mapped_params)

    # Trigger subscription state transition (handled by AASM in the Subscription model).
    # If something goes wrong here, the error will propagate and Stripe will retry the webhook.
    subscription.pay!
  end

  private

  attr_reader :mapped_params
end
