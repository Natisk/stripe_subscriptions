# frozen_string_literal: true

class ChangeSubscriptionStateColumnFromIntegerToString < ActiveRecord::Migration[7.1]
  def up
    change_column :subscriptions, :state, :string
  end

  def down
    change_column :subscriptions, :state, :integer
  end
end
