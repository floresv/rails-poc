# frozen_string_literal: true

# == Schema Information
#
# Table name: wishlists
#
#  id                :bigint           not null, primary key
#  wishlistable_type :string
#  wishlistable_id   :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_wishlists_on_wishlistable  (wishlistable_type,wishlistable_id)
#  index_wishlists_wishlistable     (wishlistable_type,wishlistable_id) UNIQUE
#
class Wishlist < ApplicationRecord
  belongs_to :wishlistable, polymorphic: true

  validates :wishlistable_id, uniqueness: { scope: :wishlistable_type }

  RANSACK_ATTRIBUTES = %w[
    id
    wishlistable_type
    wishlistable_id
    created_at
    updated_at
  ].freeze

  def self.ransackable_attributes(_auth_object = nil)
    RANSACK_ATTRIBUTES
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[wishlistable]
  end
end
