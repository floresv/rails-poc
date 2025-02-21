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
class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :unit_price, :total_price, :meal, :unit_price_cents, :unit_price_currency
  belongs_to :meal, serializer: MealSerializer

  def unit_price
    object.unit_price.format
  end

  def total_price
    object.total_price.format
  end
end 
