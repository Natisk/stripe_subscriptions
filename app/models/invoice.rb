# frozen_string_literal: true

class Invoice < ApplicationRecord
  enum status: %i[empty draft open paid void uncollectible]

  belongs_to :subscription, foreign_key: :stripe_subscription_id
end
