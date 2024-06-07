# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Subscription.all
  end
end
