# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  describe 'GET /index' do
    let!(:subscription1) { create(:subscription) }
    let!(:subscription2) { create(:subscription) }

    it 'returns a successful response' do
      get subscriptions_path
      expect(response).to be_successful
    end

    it 'renders the index template' do
      get subscriptions_path
      expect(response).to render_template(:index)
    end

    it 'assigns all subscriptions to @subscriptions and orders them' do
      get subscriptions_path
      expect(assigns(:subscriptions)).to eq([subscription2, subscription1])
    end
  end
end
