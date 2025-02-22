# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::MealsController do
  describe 'GET #index' do
    before do
      create_list(:meal, 3)
      get :index
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    context 'when the meal exists' do
      let(:meal) { create(:meal) }

      before { get :show }

      it 'returns a successful response' do
        expect(response).to be_successful
      end
    end
  end
end
