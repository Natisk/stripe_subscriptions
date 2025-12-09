# frozen_string_literal: true

class CreateStripeEventLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :stripe_event_logs do |t|
      t.string :event_id, null: false
      t.text :payload

      t.timestamps
    end

    add_index :stripe_event_logs, :event_id, unique: true
  end
end
