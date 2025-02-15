require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
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
