# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_event_log do
    event_id { 'MyString' }
    payload { '' }
  end
end
