# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::HealthController do
  describe 'GET #status' do
    before { get :status }

    it 'returns a success response' do
      expect(response).to be_successful
    end

    it 'returns http status code 200' do
      expect(response).to have_http_status(:ok)
    end
  end
end
