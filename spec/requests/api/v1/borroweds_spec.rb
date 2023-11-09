# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API::V1::Borroweds', type: :request do
  before do
    @token = '123'
  end

  path '/api/v1/borroweds' do
    get('List borroweds') do
      tags 'Borroweds'
      security [bearerAuth: []]

      response '200', 'List of borroweds fetched successfully' do
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

  path '/api/v1/borroweds/{borrowed_id}/return' do
    put('Return borrowed book') do
      tags 'Borroweds'
      security [bearerAuth: []]
      parameter name: :borrowed_id, in: :path, type: :integer, required: true

      response '200', 'Book returned successfully' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:borrowed_id) { create(:borrowed).id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('message')
          expect(data['message']).to eq('Book returned successfully')
        end
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:borrowed_id) { create(:borrowed).id } 
        run_test!
      end

      response '404', 'Borrowed not found' do
        let(:Authorization) { "Bearer #{@token}" }
        let(:borrowed_id) { 9999 }
        run_test!
      end
    end
  end
end
