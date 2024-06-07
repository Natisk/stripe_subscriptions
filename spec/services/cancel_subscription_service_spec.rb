# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CancelSubscriptionService do
  describe '#call' do
    let(:subscription_params) { double('SubscriptionParams', id: 'sub_123') }
    let(:subscription) { instance_double('Subscription', id: 1, stripe_subscription_id: 'sub_123') }

    context 'stripe origin' do
      let(:data_origin) { :stripe }

      subject { described_class.new(subscription_params, data_origin) }

      before do
        allow(Subscription).to receive(:find_by!).with({ stripe_subscription_id: 'sub_123' })
                                                 .and_return(subscription)
        allow(subscription).to receive(:cancel!)
      end

      it 'finds the subscription' do
        expect(Subscription).to receive(:find_by!).with({ stripe_subscription_id: 'sub_123' })
                                                  .and_return(subscription)
        subject.call
      end

      it 'calls cancel subscription' do
        expect(subscription).to receive(:cancel!)
        subject.call
      end
    end
  end
end
