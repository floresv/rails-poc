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
class OrderItem < ApplicationRecord
  self.ignored_columns += ['unit_price']

  belongs_to :order
  belongs_to :meal

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  monetize :unit_price_cents, as: 'unit_price'
  validates :unit_price_cents, presence: true
  validates :unit_price_currency, presence: true

  before_create :set_unit_price

  def total_price_cents
    Rails.logger.debug { "Calculating total price cents: quantity=#{quantity}, unit_price_cents=#{unit_price_cents}" }
    (quantity || 0) * (unit_price_cents || 0)
  end

  def total_price
    Money.new(total_price_cents, 'USD')
  end

  private

  def set_unit_price
    self.unit_price = meal.price
  end
end
