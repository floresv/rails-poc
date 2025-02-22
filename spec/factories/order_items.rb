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
FactoryBot.define do
  factory :order_item do
    order { nil }
    meal { nil }
    quantity { 1 }
    unit_price { '9.99' }
  end

  factory :order_item_with_meal, parent: :order_item do
    meal
  end
end
