class MealSerializer < ActiveModel::Serializer
  attributes :id, :ext_str_meal_thumb, :ext_id_meal, :name, :image_url, :price
  belongs_to:category, serializer: CategorySerializer
end