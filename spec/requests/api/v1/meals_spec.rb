require 'rails_helper'

RSpec.describe "API::V1::Meals", type: :request do
  let!(:category) { create(:category) }
  let!(:meals) { create_list(:meal, 3, category: category) }
  let!(:meal) { meals.first }

  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/meals"
      expect(response).to have_http_status(:success)
    end

    it "returns meals in JSON format" do
      get "/api/v1/meals"
      expect(response.content_type).to match(/application\/json/)
    end

    it "returns all meals with pagination metadata" do
      get "/api/v1/meals"
      json_response = JSON.parse(response.body)
      
      expect(json_response['meals']).to be_present
      expect(json_response['meta']).to include(
        'currentPage',
        'totalPages',
        'totalCount',
        'perPage'
      )
    end

    context "with category filter" do
      it "returns meals filtered by category" do
        get "/api/v1/meals", params: { category_id: category.id }
        json_response = JSON.parse(response.body)
        
        expect(json_response['meals'].length).to eq(3)
      end
    end

    context "with pagination params" do
      it "respects per_page parameter" do
        get "/api/v1/meals", params: { per_page: 2 }
        json_response = JSON.parse(response.body)
        
        expect(json_response['meals'].length).to eq(2)
        expect(json_response['meta']['perPage']).to eq(2)
      end
    end
  end

  describe "GET /show" do
    context "when meal exists" do
      it "returns http success" do
        get "/api/v1/meals/#{meal.id}"
        expect(response).to have_http_status(:success)
      end

      it "returns the correct meal" do
        get "/api/v1/meals/#{meal.id}"
        json_response = JSON.parse(response.body)
        
        expect(json_response['meal']['id']).to eq(meal.id)
      end
    end

    context "when meal does not exist" do
      it "returns http not found" do
        get "/api/v1/meals/0"
        expect(response).to have_http_status(:not_found)
      end

      it "returns error message" do
        get "/api/v1/meals/0"
        json_response = JSON.parse(response.body)
        
        expect(json_response['error']).to eq("Meal not found")
      end
    end
  end
end