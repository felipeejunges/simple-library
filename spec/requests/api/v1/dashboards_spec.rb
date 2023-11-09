# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API::V1::Dashboards', type: :request do
  before do
    @token = '123'
  end

  path '/api/v1/dashboards' do
    get('Dashboard data') do
      tags 'Dashboards'
      security [bearerAuth: []]

      response '200', 'Dashboard data fetched successfully' do
        let(:Authorization) { "Bearer #{@token}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).not_to be_empty
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end
  end
end
