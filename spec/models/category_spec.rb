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
require 'rails_helper'
require 'spec_helper'

RSpec.describe Category do
  describe 'validations' do
    subject { build(:category) }

    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'attributes' do
    it 'has expected attributes' do
      attributes = %i[
        id
        name
        ext_id
        ext_str_category_humb
        ext_str_category_description
      ]

      expect(described_class.new.attributes.keys).to include(*attributes.map(&:to_s))
    end
  end
end
