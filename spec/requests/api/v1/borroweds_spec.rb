# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/borroweds', type: :request do
  path '/api/v1/borroweds/{borrowed_id}/return_book' do
    # You'll want to customize the parameter types...
    parameter name: 'borrowed_id', in: :path, type: :string, description: 'borrowed_id'

    patch('return_book borrowed') do
      response(200, 'successful') do
        let(:borrowed_id) { '123' }

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

  path '/api/v1/borroweds' do
    get('list borroweds') do
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
