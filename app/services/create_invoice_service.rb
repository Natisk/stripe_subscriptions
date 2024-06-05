# frozen_string_literal: true

class CreateInvoiceService < BaseService
  def initialize(invoice_params, data_origin)
    @invoice_params = invoice_params
    @data_origin = data_origin
  end

  def call
    mapped_params = case data_origin
                    when :stripe
                      StripeInvoiceMapper.new(invoice_params).call
                    end

    subscription = Subscription.find_by!(params_to_find)
    subscription.invoices.create!(mapped_params)
    # guarded in model by aasm
    subscription.pay!
  end

  private

  attr_reader :invoice_params, :data_origin

  def params_to_find
    case data_origin
    when :stripe
      { stripe_subscription_id: invoice_params.subscription }
    end
  end
end
