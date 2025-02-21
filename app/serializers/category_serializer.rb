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
class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :ext_id, :ext_str_category_humb, :ext_str_category_description
end
