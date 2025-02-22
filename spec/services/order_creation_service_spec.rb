# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderCreationService do
  subject(:service) { described_class.new(order_params) }

  let(:meal) { create(:meal, price_cents: 1500) }
  let(:order_params) do
    {
      username: 'john_doe',
      email: 'john@example.com',
      order_items_attributes: [
        { meal_id: meal.id, quantity: 2 }
      ]
    }
  end

  describe '#call' do
    context 'when the order is created successfully' do
      it 'creates a new order with the correct attributes' do
        order = service.call

        expect(order).to be_persisted
        expect(order.username).to eq('john_doe')
        expect(order.email).to eq('john@example.com')
        expect(order.state).to eq('pending_of_payment')
        expect(order.total_cents).to eq(3000) # 1500 * 2

        order_item = order.order_items.first
        expect(order_item.meal).to eq(meal)
        expect(order_item.quantity).to eq(2)
        expect(order_item.unit_price_cents).to eq(1500)
      end
    end

    context 'when a meal does not exist' do
      before { order_params[:order_items_attributes].first[:meal_id] = 999_999 }

      it 'raises an ActiveRecord::RecordNotFound error' do
        expect { service.call }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when order creation fails' do
      let(:invalid_order) { Order.new }

      before do
        allow(Order).to receive(:new).and_return(invalid_order)
        allow(invalid_order).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(invalid_order))
      end

      it 'raises an ActiveRecord::RecordInvalid error' do
        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
