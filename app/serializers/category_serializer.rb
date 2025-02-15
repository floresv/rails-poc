class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :ext_id, :ext_str_category_humb, :ext_str_category_description
end
