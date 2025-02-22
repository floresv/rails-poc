# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::CategoriesController do
  describe 'GET #index' do
    before do
      create_list(:category, 3)
      get :index
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    context 'when the category exists' do
      let(:category) { create(:category) }

      before { get :show }

      it 'returns a successful response' do
        expect(response).to be_successful
      end
    end
  end
end
