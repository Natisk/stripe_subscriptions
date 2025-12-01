# frozen_string_literal: true
class RenameStripeCustomerIdAndStripeSubscriptionId < ActiveRecord::Migration[7.1]
  def change
    rename_column :subscriptions, :stripe_customer_id, :customer_id
    rename_column :subscriptions, :stripe_subscription_id, :external_id
  end
end
