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
  has_many :meals, dependent: :destroy

  validates :name, presence: true

  RANSACK_ATTRIBUTES = %w[
    id
    name
    ext_id
    ext_str_category_humb
    ext_str_category_description
    created_at
    updated_at
  ].freeze

  def self.ransackable_attributes(_auth_object = nil)
    RANSACK_ATTRIBUTES
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[meals]
  end
end
