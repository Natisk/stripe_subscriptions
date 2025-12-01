# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateInvoiceService do
  describe '#call' do
    let(:subscription) { instance_double('Subscription') }
    let(:invoice) { instance_double('Invoice') }

    let(:mapped_params) do
      {
        external_id: 'sub_123',
        customer_id: 'cus_123',
        amount_paid: 1000,
        currency: 'usd'
      }
    end

    subject { described_class.new(mapped_params) }

    before do
      allow(Subscription).to receive(:find_by!)
        .with(external_id: mapped_params[:external_id],
              customer_id: mapped_params[:customer_id])
        .and_return(subscription)

      invoices_double = double('invoices')
      allow(subscription).to receive(:invoices).and_return(invoices_double)
      allow(invoices_double).to receive(:create!).with(mapped_params).and_return(invoice)

      allow(subscription).to receive(:pay!)
    end

    it 'finds the subscription by external_id and customer_id' do
      subject.call
      expect(Subscription).to have_received(:find_by!).with(
        external_id: mapped_params[:external_id],
        customer_id: mapped_params[:customer_id]
      )
    end

    it 'creates a new invoice associated with the subscription' do
      subject.call
      expect(subscription.invoices).to have_received(:create!).with(mapped_params)
    end

    it 'calls pay! on the subscription' do
      subject.call
      expect(subscription).to have_received(:pay!)
    end

    context 'when subscription does not exist' do
      before do
        allow(Subscription).to receive(:find_by!).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'raises ActiveRecord::RecordNotFound' do
        expect { subject.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
