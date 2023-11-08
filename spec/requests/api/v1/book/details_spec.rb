# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/book/details', type: :request do
  path '/api/v1/books/{book_id}/details' do
    # You'll want to customize the parameter types...
    parameter name: 'book_id', in: :path, type: :string, description: 'book_id'

    post('create detail') do
      response(200, 'successful') do
        let(:book_id) { '123' }

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

  path '/api/v1/books/{book_id}/details/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'book_id', in: :path, type: :string, description: 'book_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show detail') do
      response(200, 'successful') do
        let(:book_id) { '123' }
        let(:id) { '123' }

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

    patch('update detail') do
      response(200, 'successful') do
        let(:book_id) { '123' }
        let(:id) { '123' }

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

    put('update detail') do
      response(200, 'successful') do
        let(:book_id) { '123' }
        let(:id) { '123' }

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

    delete('delete detail') do
      response(200, 'successful') do
        let(:book_id) { '123' }
        let(:id) { '123' }

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
