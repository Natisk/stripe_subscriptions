# frozen_string_literal: true

class AddSubscriptionIdToInvoice < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :subscription_id, :integer
  end
end
