# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API::V1::Book::Details', type: :request do
  before do
    @token = '123'
  end

  path '/api/v1/books/{book_id}/details' do
    get('Show book detail') do
      tags 'Book Details'
      security [bearerAuth: []]
      parameter name: :book_id, in: :path, type: :integer, required: true

      response '200', 'Book detail fetched successfully' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { create(:book).id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).not_to be_empty
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:book_id) { create(:book).id } 
        run_test!
      end

      response '404', 'Book not found' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { 9999 }
        run_test!
      end
    end

    post('Create book detail') do
      tags 'Book Details'
      security [bearerAuth: []]
      parameter name: :book_id, in: :path, type: :integer, required: true
      parameter name: :detail, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Detail name' },
          description: { type: :string, description: 'Detail description' }
        },
        required: %w[name description]
      }

      response '201', 'Book detail created successfully' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { create(:book).id }
        let(:detail) { { name: 'Sample Detail', description: 'Sample Description' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('id')
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:book_id) { create(:book).id }
        let(:detail) { { name: 'Sample Detail', description: 'Sample Description' } }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { create(:book).id }
        let(:detail) { { name: 'Sample Detail' } }
        run_test!
      end

      response '404', 'Book not found' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { 9999 } 
        let(:detail) { { name: 'Sample Detail', description: 'Sample Description' } }
        run_test!
      end
    end

    patch('Update book detail') do
      tags 'Book Details'
      security [bearerAuth: []]
      parameter name: :book_id, in: :path, type: :integer, required: true
      parameter name: :detail, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Detail name' },
          description: { type: :string, description: 'Detail description' }
        }
      }

      response '200', 'Book detail updated successfully' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { create(:book).id } 
        let(:detail) { { name: 'Updated Detail', description: 'Updated Description' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('id')
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:book_id) { create(:book).id }
        let(:detail) { { name: 'Updated Detail', description: 'Updated Description' } }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { create(:book).id } 
        let(:detail) { { name: 'Updated Detail' } }
        run_test!
      end

      response '404', 'Book not found' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { 9999 } 
        let(:detail) { { name: 'Updated Detail', description: 'Updated Description' } }
        run_test!
      end
    end

    delete('Delete book detail') do
      tags 'Book Details'
      security [bearerAuth: []]
      parameter name: :book_id, in: :path, type: :integer, required: true

      response '204', 'Book detail deleted successfully' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { create(:book).id }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:book_id) { create(:book).id } 
        run_test!
      end

      response '404', 'Book not found' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { 9999 } 
        run_test!
      end
    end

    post('Return book') do
      tags 'Book Details'
      security [bearerAuth: []]
      parameter name: :book_id, in: :path, type: :integer, required: true

      response '200', 'Book returned successfully' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { create(:book).id }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:book_id) { create(:book).id }
        run_test!
      end

      response '404', 'Book not found' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:book_id) { 9999 }
        run_test!
      end
    end
  end
end
