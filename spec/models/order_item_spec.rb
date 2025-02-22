# frozen_string_literal: true

# == Schema Information
#
# Table name: order_items
#
#  id                  :bigint           not null, primary key
#  order_id            :bigint           not null
#  meal_id             :bigint           not null
#  quantity            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  unit_price_cents    :integer
#  unit_price_currency :string           default("USD"), not null
#
# Indexes
#
#  index_order_items_on_meal_id   (meal_id)
#  index_order_items_on_order_id  (order_id)
#
require 'rails_helper'
require 'spec_helper'

RSpec.describe OrderItem do
  let(:meal) { create(:meal, price_cents: 1500) }
  let(:order) { create(:order) }
  let(:order_item) do
    build(:order_item, meal: meal, order: order, quantity: 2, unit_price_cents: 999, unit_price_currency: nil)
  end
  let(:valid_order_item) do
    build(:order_item, meal: meal, order: order, quantity: 2, unit_price_cents: 999, unit_price_currency: 'USD')
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(valid_order_item).to be_valid
    end

    it 'is not valid without a quantity' do
      order_item.quantity = nil
      expect(order_item).not_to be_valid
    end

    it 'is not valid with a quantity less than or equal to zero' do
      order_item.quantity = 0
      expect(order_item).not_to be_valid
    end

    it 'is not valid without a unit price' do
      order_item.unit_price_cents = nil
      expect(order_item).not_to be_valid
      expect(order_item.errors[:unit_price_cents]).to include("can't be blank")
    end

    it 'is not valid without a unit price currency' do
      order_item.unit_price_currency = nil
      expect(order_item).not_to be_valid
      expect(order_item.errors[:unit_price_currency]).to include("can't be blank")
    end
  end

  describe '#total_price_cents' do
    it 'calculates the total price in cents' do
      expect(order_item.total_price_cents).to eq(order_item.unit_price_cents * order_item.quantity)
    end
  end

  describe '#total_price' do
    it 'returns a Money object representing the total price' do
      expect(order_item.total_price).to be_a(Money)
      expect(order_item.total_price.cents).to eq(1998)
    end
  end
end
