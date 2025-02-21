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

RSpec.describe OrderItem, type: :model do
  let(:meal) { create(:meal, price_cents: 1500) }
  let(:order_item) { build(:order_item, meal: meal, quantity: 2) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(order_item).to be_valid
    end

    it 'is not valid without a quantity' do
      order_item.quantity = nil
      expect(order_item).to_not be_valid
    end

    it 'is not valid with a quantity less than or equal to zero' do
      order_item.quantity = 0
      expect(order_item).to_not be_valid
    end
  end

  describe '#total_price_cents' do
    it 'calculates the total price in cents' do
      expect(order_item.total_price_cents).to eq(3000) # 1500 * 2
    end
  end

  describe '#total_price' do
    it 'returns a Money object representing the total price' do
      expect(order_item.total_price).to be_a(Money)
      expect(order_item.total_price.cents).to eq(3000) # 1500 * 2
    end
  end

  describe '#set_unit_price' do
    it 'sets the unit price from the associated meal' do
      order_item.save
      expect(order_item.unit_price_cents).to eq(meal.price_cents)
    end
  end
end
