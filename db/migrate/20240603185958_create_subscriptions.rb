class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :stripe_customer_id
      t.string :stripe_subscription_id
      t.integer :state, default: 0

      t.timestamps
    end
  end
end
