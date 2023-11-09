# spec/requests/api/v1/users_spec.rb

require 'swagger_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let(:user) { create(:user) }
  
  path '/api/v1/users' do
    get('List users') do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Users per page'
      parameter name: :sort_by, in: :query, type: :string, description: 'Sort by field (id, first_name, last_name, email)'
      parameter name: :sort_order, in: :query, type: :string, description: 'Sort order (ASC, DESC)'

      response '200', 'List of users' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   first_name: { type: :string },
                   last_name: { type: :string },
                   email: { type: :string }
                 },
                 required: %w[id first_name last_name email]
               }

        run_test!
      end
    end

    post('Create user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string, description: 'First Name' },
          last_name: { type: :string, description: 'Last Name' },
          email: { type: :string, format: :email, description: 'Email Address' }
        },
        required: %w[first_name last_name email]
      }

      response '201', 'User created successfully' do
        run_test!
      end

      response '422', 'Invalid parameters' do
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'User ID'

    get('Show user') do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'User details' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 first_name: { type: :string },
                 last_name: { type: :string },
                 email: { type: :string }
               },
               required: %w[id first_name last_name email]

        run_test!
      end

      response '404', 'User not found' do
        run_test!
      end
    end

    put('Update user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string, description: 'First Name' },
          last_name: { type: :string, description: 'Last Name' },
          email: { type: :string, format: :email, description: 'Email Address' }
        }
      }

      response '200', 'User updated successfully' do
        run_test!
      end

      response '404', 'User not found' do
        run_test!
      end

      response '422', 'Invalid parameters' do
        run_test!
      end
    end

    delete('Delete user') do
      tags 'Users'
      security [bearerAuth: []]

      response '204', 'User deleted successfully' do
        run_test!
      end

      response '404', 'User not found' do
        run_test!
      end
    end
  end
end
