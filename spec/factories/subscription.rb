# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    sequence(:customer_id) { |n| "cus_test_#{n}" }
    sequence(:external_id) { |n| "sub_test_#{n}" }
    state { Subscription::STATE_UNPAID }
  end
end
