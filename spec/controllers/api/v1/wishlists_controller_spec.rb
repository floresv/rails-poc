# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::WishlistsController do
  let(:meal) { create(:meal) }
  let(:wishlist) { create(:wishlist) }
  let(:valid_attributes) do
    {
      wishlistable_type: 'Meal',
      wishlistable_id: meal.id
    }
  end

  describe 'GET /api/v1/wishlists' do
    before { get '/api/v1/wishlists' }

    it 'returns a success response' do
      expect(response).to be_successful
    end
  end

  describe 'POST /api/v1/wishlists' do
    context 'with valid params' do
      before do
        post '/api/v1/wishlists'
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'creates a new Wishlist' do
        expect(Wishlist.count).to eq(0)
      end
    end
  end

  describe 'DELETE /api/v1/wishlists/:id' do
    let!(:wishlist_to_delete) { create(:wishlist) }

    before do
      delete "/api/v1/wishlists/#{wishlist_to_delete.id}"
    end

    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'destroys the requested wishlist' do
      expect(Wishlist.count).to eq(1)
    end
  end
end
