# frozen_string_literal: true

# == Schema Information
#
# Table name: meals
#
#  id                 :bigint           not null, primary key
#  category_id        :integer
#  ext_str_meal_thumb :string
#  ext_id_meal        :integer
#  name               :string
#  image_url          :string
#  price              :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  price_cents        :integer
#  price_currency     :string           default("USD"), not null
#
require 'rails_helper'
require 'spec_helper'

RSpec.describe Meal do
  let(:category) { create(:category) }
  let(:meal) { build(:meal, category: category, price: nil) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      meal.price = 1500
      expect(meal).to be_valid
    end

    it 'is not valid without a name' do
      meal = build(:meal, name: nil)
      expect(meal).not_to be_valid
    end

    it 'is not valid without a price' do
      meal.price_cents = nil
      expect(meal).not_to be_valid
      expect(meal.errors[:price_cents]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category) }
  end

  describe 'attributes' do
    it 'has expected attributes' do
      meal = build(:meal)
      expect(meal).to respond_to(:id)
      expect(meal).to respond_to(:ext_str_meal_thumb)
      expect(meal).to respond_to(:ext_id_meal)
      expect(meal).to respond_to(:name)
      expect(meal).to respond_to(:image_url)
      expect(meal).to respond_to(:price)
    end
  end
end
