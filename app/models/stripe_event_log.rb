# frozen_string_literal: true

# A Class to monitor stripe events activity
class StripeEventLog < ApplicationRecord
  serialize :payload, JSON

  validates :event_id, presence: true, uniqueness: true
end
