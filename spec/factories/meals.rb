FactoryBot.define do
  factory :meal do
    name { "Sample Meal" }
    ext_str_meal_thumb { "http://example.com/thumb.jpg" }
    ext_id_meal { "123" }
    image_url { "http://example.com/image.jpg" }
    price { 9.99 }
    association :category
  end
end
