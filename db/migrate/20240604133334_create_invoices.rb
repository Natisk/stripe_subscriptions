class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.string :stripe_customer_id
      t.string :stripe_subscription_id
      t.string :account_country
      t.decimal :amount_due
      t.decimal :amount_paid
      t.decimal :amount_remaining
      t.decimal :amount_shipping
      t.string :billing
      t.string :charge
      t.string :currency
      t.boolean :paid, default: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
