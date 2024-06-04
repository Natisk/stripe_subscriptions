# frozen_string_literal: true

class Subscription < ApplicationRecord
  # default state is :unpaid
  enum state: %i[unpaid paid canceled]
end
