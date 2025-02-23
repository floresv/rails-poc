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
class WishlistSerializer < ActiveModel::Serializer
  attributes :id, :wishlistable_type, :wishlistable_id, :created_at

  belongs_to :wishlistable, polymorphic: true

  def wishlistable
    case object.wishlistable_type
    when 'Meal'
      MealSerializer.new(object.wishlistable).as_json
    end
  end
end
