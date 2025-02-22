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
FactoryBot.define do
  factory :meal do
    name { 'Sample Meal' }
    ext_str_meal_thumb { 'http://example.com/thumb.jpg' }
    ext_id_meal { '123' }
    image_url { 'http://example.com/image.jpg' }
    price { 9.99 }
    category
  end
end
