# frozen_string_literal: true

class Subscription < ApplicationRecord
  include AASM

  has_many :invoices

  aasm column: :state, requires_lock: true, whiny_transitions: false do
    state :unpaid, initial: true
    state :paid, :canceled

    event :pay do
      transitions from: :unpaid, to: :paid, guard: :invoice_paid?
    end

    event :cancel do
      transitions from: :paid, to: :canceled, guard: :paid?
    end
  end

  private

  def invoice_paid?
    invoices.first.paid?
  end
end
