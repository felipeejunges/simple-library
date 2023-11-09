# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::UserSessions', type: :request do
  path '/api/v1/login' do
    post('Authenticate user') do
      tags 'User Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email, description: 'User email', example: 'user@example.com' },
          password: { type: :string, description: 'User password', example: 'password' }
        },
        required: %w[email password]
      }

      response '201', 'User authenticated successfully' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('token')
        end
      end

      response '422', 'Invalid email or password' do
        let(:user) { { email: 'invalid@example.com', password: 'wrongpassword' } }
        run_test!
      end

      response '500', 'Internal Server Error' do
        let(:user) { { email: 'error@example.com', password: 'errorpassword' } }
        run_test!
      end
    end
  end
end
