# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stripe::SubscriptionMapper do
  describe '#call' do
    let(:subscription_params) { double('SubscriptionParams', customer: 'cus_123', id: 'sub_123') }
    let(:mapped_params) { { customer_id: 'cus_123', external_id: 'sub_123' } }

    subject { described_class.new(subscription_params) }

    it 'maps the subscription params correctly' do
      expect(subject.call).to eq(mapped_params)
    end

    context 'with missing customer' do
      let(:subscription_params) { double('SubscriptionParams', customer: nil, id: 'sub_123') }
      let(:mapped_params) { { customer_id: nil, external_id: 'sub_123' } }

      it 'handles missing customer' do
        expect(subject.call).to eq(mapped_params)
      end
    end

    context 'with missing id' do
      let(:subscription_params) { double('SubscriptionParams', customer: 'cus_123', id: nil) }
      let(:mapped_params) { { customer_id: 'cus_123', external_id: nil } }

      it 'handles missing id' do
        expect(subject.call).to eq(mapped_params)
      end
    end
  end
end
