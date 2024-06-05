# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    assosiation { :subscription }
    status { 'empty' }
  end

  trait :paid do
    status { 'paid' }
  end
end
