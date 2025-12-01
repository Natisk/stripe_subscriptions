# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CancelSubscriptionService do
  describe '#call' do
    let(:subscription_id) { 'sub_123' }
    let(:subscription) { instance_double('Subscription', id: 1, external_id: 'sub_123') }

    context 'stripe origin' do
      subject { described_class.new(subscription_id) }

      before do
        allow(Subscription).to receive(:find_by!).with({ external_id: 'sub_123' })
                                                 .and_return(subscription)
        allow(subscription).to receive(:cancel!)
      end

      it 'finds the subscription' do
        expect(Subscription).to receive(:find_by!).with({ external_id: 'sub_123' })
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
