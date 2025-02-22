# frozen_string_literal: true

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
class Category < ApplicationRecord
  validates :name, presence: true
end
