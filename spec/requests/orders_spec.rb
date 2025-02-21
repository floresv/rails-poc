# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  username       :string
#  email          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  total_cents    :integer
#  total_currency :string           default("USD"), not null
#  state          :string           default("pending_of_payment"), not null
#
require 'rails_helper'

RSpec.describe "/orders", type: :request do
  
  let(:valid_attributes) {
    {
      username: "john_doe",
      email: "john@example.com",
      total_cents: 5000,
      state: "pending_of_payment"
    }
  }

  let(:invalid_attributes) {
    {
      username: nil, # Invalid because username is required
      email: "invalid_email", # Invalid email format
      total_cents: nil # Invalid because total_cents is required
    }
  }

  let!(:order) { Order.create!(valid_attributes) }

  describe "GET /index" do
    it "renders a successful response" do
      Order.create! valid_attributes
      get orders_url
      expect(response).to be_successful
    end

    it "returns a list of orders" do
      Order.create! valid_attributes
      Order.create! valid_attributes.merge(username: "jane_doe", email: "jane@example.com")

      get orders_url
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)
      expect(json_response[0]['username']).to eq("john_doe")
      expect(json_response[1]['username']).to eq("jane_doe")
    end

    it "returns the correct attributes for each order" do
      order = Order.create! valid_attributes
      get orders_url
      json_response = JSON.parse(response.body)

      expect(json_response[0]).to include(
        'id' => order.id,
        'username' => order.username,
        'email' => order.email,
        'total' => order.total.format,
        'state' => order.state
      )
    end
  end

  describe "GET /show" do
    context "when the order exists" do
      before { get "/api/v1/orders/#{order.id}" }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns the order" do
        json_response = JSON.parse(response.body)
        expect(json_response).not_to be_empty
        expect(json_response).to include(
          'id' => order.id,
          'username' => order.username,
          'email' => order.email,
          'total' => order.total.format,
          'state' => order.state
        )
      end
    end

    context "when the order does not exist" do
      before { get "/api/v1/orders/999999" }

      it "returns http not found" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found message" do
        expect(JSON.parse(response.body)['error']).to eq("Order not found")
      end
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_order_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      order = Order.create! valid_attributes
      get edit_order_url(order)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Order" do
        expect {
          post orders_url, params: { order: valid_attributes }
        }.to change(Order, :count).by(1)
      end

      it "renders a JSON response with the new order" do
        post orders_url, params: { order: valid_attributes }
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'id',
          'username' => valid_attributes[:username],
          'email' => valid_attributes[:email],
          'total' => valid_attributes[:total_cents].to_s,
          'state' => 'pending_of_payment'
        )
      end
    end

    context "with invalid parameters" do
      it "does not create a new Order" do
        expect {
          post orders_url, params: { order: invalid_attributes }
        }.to change(Order, :count).by(0)
      end

      it "renders a JSON response with errors" do
        post orders_url, params: { order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Username can't be blank", "Email is invalid", "Total cents can't be blank")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested order" do
        order = Order.create! valid_attributes
        patch order_url(order), params: { order: new_attributes }
        order.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the order" do
        order = Order.create! valid_attributes
        patch order_url(order), params: { order: new_attributes }
        order.reload
        expect(response).to redirect_to(order_url(order))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        order = Order.create! valid_attributes
        patch order_url(order), params: { order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    context "when the order exists" do
      it "destroys the requested order" do
        expect {
          delete "/api/v1/orders/#{order.id}"
        }.to change(Order, :count).by(-1)
      end

      it "returns http no content" do
        delete "/api/v1/orders/#{order.id}"
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the order does not exist" do
      it "returns http not found" do
        delete "/api/v1/orders/999999" # Use a non-existent ID
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found message" do
        delete "/api/v1/orders/999999" # Use a non-existent ID
        expect(JSON.parse(response.body)['error']).to eq("Order not found")
      end
    end
  end

  describe "POST /pay" do
    context "when the order exists and is pending" do
      it "marks the order as paid" do
        post "/api/v1/orders/#{order.id}/pay"
        order.reload
        expect(order.state).to eq('paid')
      end

      it "returns the order details" do
        post "/api/v1/orders/#{order.id}/pay"
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to include(
          'id' => order.id,
          'username' => order.username,
          'email' => order.email,
          'total' => order.total.format,
          'state' => 'paid'
        )
      end
    end

    context "when the order is already paid" do
      before { order.mark_as_paid } # Mark the order as paid before testing

      it "does not allow marking the order as paid again" do
        post "/api/v1/orders/#{order.id}/pay"
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Order is already paid.")
      end
    end

    context "when the order does not exist" do
      it "returns http not found" do
        post "/api/v1/orders/999999/pay" # Use a non-existent ID
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to eq("Order not found")
      end
    end
  end
end
