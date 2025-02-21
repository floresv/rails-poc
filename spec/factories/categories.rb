# == Schema Information
#
# Table name: categories
#
#  id                           :bigint           not null, primary key
#  name                         :string
#  ext_id                       :integer
#  ext_str_category_humb        :string
#  ext_str_category_description :text
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
FactoryBot.define do
  factory :category do
    name { "MyString" }
    ext_id { 1 }
    ext_str_category_humb { "MyString" }
    ext_str_category_description { "MyText" }
  end
end
