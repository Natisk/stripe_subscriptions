# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Subscription.order(created_at: :desc).limit(20)
  end
end
