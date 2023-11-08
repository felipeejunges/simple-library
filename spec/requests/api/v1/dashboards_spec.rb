# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/dashboards', type: :request do
  path '/api/v1/dashboard' do
    get('list dashboards') do
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
