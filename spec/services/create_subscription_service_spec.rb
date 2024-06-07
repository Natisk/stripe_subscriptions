# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateSubscriptionService do
  describe '#call' do
    let(:subscription_params) { { id: 'sub_123', customer: 'cus_123' } }
    let(:mapped_params) { { external_id: 'sub_123', customer_id: 'cus_123' } }  
    let(:subscription) { instance_double(Subscription) }  

    context 'stripe origin' do
      let(:data_origin) { :stripe }
      let(:stripe_mapper) { instance_double(Stripe::SubscriptionMapper, call: mapped_params) }

      subject { described_class.new(subscription_params, data_origin) }

      before do
        allow(Stripe::SubscriptionMapper).to receive(:new).with(subscription_params).and_return(stripe_mapper)
      end

      it 'calls create a subscription' do
        expect(Subscription).to receive(:create!).with(mapped_params)
        subject.call
      end
    end
  end
end
