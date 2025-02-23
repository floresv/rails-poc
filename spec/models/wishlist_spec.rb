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
require 'rails_helper'
require 'spec_helper'

RSpec.describe Wishlist do
  let(:meal) { create(:meal) }
  let(:wishlist) { build(:wishlist, wishlistable: meal) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(wishlist).to be_valid
    end

    it 'is not valid without a wishlistable item' do
      wishlist.wishlistable = nil
      expect(wishlist).not_to be_valid
      expect(wishlist.errors[:wishlistable]).to include('must exist')
    end

    it 'enforces uniqueness of wishlistable' do
      wishlist.save!
      duplicate_wishlist = build(:wishlist, wishlistable: meal)
      expect(duplicate_wishlist).not_to be_valid
      expect(duplicate_wishlist.errors[:wishlistable_id]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:wishlistable) }
  end

  describe 'attributes' do
    it 'has expected attributes' do
      expect(wishlist).to respond_to(:id)
      expect(wishlist).to respond_to(:wishlistable_type)
      expect(wishlist).to respond_to(:wishlistable_id)
      expect(wishlist).to respond_to(:created_at)
      expect(wishlist).to respond_to(:updated_at)
    end
  end

  describe 'ransackable attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = %w[
        id
        wishlistable_type
        wishlistable_id
        created_at
        updated_at
      ]

      expect(described_class.ransackable_attributes).to match_array(expected_attributes)
    end

    it 'returns the correct ransackable associations' do
      expected_associations = %w[wishlistable]
      expect(described_class.ransackable_associations).to match_array(expected_associations)
    end
  end
end
