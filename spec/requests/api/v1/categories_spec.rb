require 'rails_helper'

RSpec.describe "API::V1::Categories", type: :request do
  let!(:category) { create(:category) }

  describe "GET /index" do
    before { get "/api/v1/categories" }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns categories with pagination metadata" do
      json_response = JSON.parse(response.body)
      expect(json_response['meta']).to include(
        'currentPage',
        'totalPages',
        'totalCount',
        'perPage'
      )
    end
  end

  describe "GET /show" do
    context "when the category exists" do
      before { get "/api/v1/categories/#{category.id}" }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns the category" do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        puts "Response: #{json_response.inspect}"
        expect(json_response['category']).to include(
          'id',
          'name',
          'extId',
          'extStrCategoryHumb',
          'extStrCategoryDescription'
        )
        expect(json_response['category']['id']).to eq(category.id)
      end
    end

    context "when the category does not exist" do
      before { get "/api/v1/categories/999999" }

      it "returns http not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found message" do
        expect(JSON.parse(response.body)['error']).to eq("Category not found")
      end
    end
  end
end
