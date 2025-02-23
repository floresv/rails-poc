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
FactoryBot.define do
  factory :wishlist do
    wishlistable factory: %i[meal]

    trait :with_meal do
      wishlistable factory: %i[meal]
    end
  end
end
