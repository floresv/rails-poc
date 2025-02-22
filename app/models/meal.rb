# frozen_string_literal: true

# == Schema Information
#
# Table name: meals
#
#  id                 :bigint           not null, primary key
#  category_id        :integer
#  ext_str_meal_thumb :string
#  ext_id_meal        :integer
#  name               :string
#  image_url          :string
#  price              :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  price_cents        :integer
#  price_currency     :string           default("USD"), not null
#
class Meal < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  validates :name, presence: true
  validates :price_cents, presence: true
  validates :price_currency, presence: true

  monetize :price_cents, as: 'price'
end
