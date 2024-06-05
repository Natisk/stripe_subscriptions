# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'changes state' do
    context 'when just created' do
      it 'has default state :unpaid and cannot be canceled' do
        subscription = create(:subscription)

        expect(subscription.state).to eq(Subscription::STATE_UNPAID.to_s)
        expect { subscription.cancel! }.not_to change(subscription, :state)
      end
    end

    context 'when invoice created' do
      it 'changes state from :unpaid to :paid if invoice is :paid' do
        subscription = create(:subscription)
        subscription.invoices.create(status: 'paid')

        expect { subscription.pay! }.to change(subscription, :state)
      end

      it 'doesnt change status from :unpaid to :paid if invoice is not :paid' do
        subscription = create(:subscription)
        subscription.invoices.create(status: 'draft')

        expect { subscription.pay! }.not_to change(subscription, :state)
      end
    end

    context 'when state is :paid' do
      it 'can be canceled' do
        subscription = create(:subscription, state: Subscription::STATE_PAID)

        expect { subscription.cancel! }.to change(subscription, :state)
        expect(subscription.state).to eq(Subscription::STATE_CANCELED.to_s)
      end
    end
  end
end
