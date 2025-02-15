FactoryBot.define do
  factory :meal do
    category { nil }
    ext_str_meal_thumb { "MyString" }
    ext_id_meal { 1 }
    name { "MyString" }
    image_url { "MyString" }
    price { "9.99" }
  end
end
