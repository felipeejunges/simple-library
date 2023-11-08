# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UserSessionsController, type: :controller do
  describe 'POST #authenticate' do
    let!(:user) { create(:user, email: 'user@example.com') }

    context 'with valid credentials' do
      it 'authenticates user and returns token' do
        post :authenticate, params: { user: { email: 'user@example.com', password: '123' } }
        expect(response).to have_http_status(:success)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key('token')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized error' do
        post :authenticate, params: { user: { email: 'user@example.com', password: 'wrong_password' } }
        expect(response).to have_http_status(:unauthorized)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq('Invalid email or password')
      end
    end
  end
end
