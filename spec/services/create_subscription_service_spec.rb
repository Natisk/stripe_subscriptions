# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateSubscriptionService do
  describe '#call' do
    let(:subscription_params) { { id: 'sub_123', customer: 'cus_123' } }
    subject { described_class.new(subscription_params) }

    it 'calls create a subscription' do
      expect(Subscription).to receive(:create!).with(subscription_params)
      subject.call
    end
  end
end
