class Subscription < ApplicationRecord
  enum state: i%(unpaid paid canceled)
end
