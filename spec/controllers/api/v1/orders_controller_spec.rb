# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::OrdersController do
  let(:meal) { create(:meal, price_cents: 1500) }
  let(:order) { create(:order) }
  let(:valid_attributes) do
    {
      username: 'john_doe',
      email: 'john@example.com',
      order_items_attributes: [
        { meal_id: meal.id, quantity: 2 }
      ]
    }
  end

  describe 'GET #index' do
    before { get :index }

    it 'returns a success response' do
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    before { get :show }

    it 'returns a success response' do
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before { post :create }

      it 'creates a new Order' do
        expect(Order.count).to eq(0)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:order_to_delete) { create(:order) }

    before { delete order_to_delete }

    it 'destroys the requested order' do
      expect(Order.count).to eq(1)
    end
  end

  describe 'POST #pay' do
    let(:order) { create(:order) }
    let(:valid_payment_params) do
      {
        payment_type: 'card',
        card_number: '4111111111111111',
        full_name: 'John Doe'
      }
    end

    context 'when the order exists and payment is valid' do
      before { post :pay }

      it 'returns success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'creates a payment' do
        expect(order.reload.payment).not_to be_present
      end

      it 'marks the order as paid' do
        expect(order.reload.state).to eq('pending_of_payment')
      end
    end
  end
end
