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
class MealSerializer < ActiveModel::Serializer
  attributes :id, :ext_str_meal_thumb, :ext_id_meal, :name, :image_url, :price
  belongs_to:category, serializer: CategorySerializer

  def price
    object.price.format
  end
end
