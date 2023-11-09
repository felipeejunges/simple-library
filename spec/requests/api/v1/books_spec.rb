# spec/requests/api/v1/books_spec.rb

require 'swagger_helper'

RSpec.describe 'Api::V1::Books', type: :request do
  let(:user) { create(:user) }
  let(:book) { create(:book) } 

  path '/api/v1/books' do
    get('List books') do
      tags 'Books'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Books per page'
      parameter name: :sort_by, in: :query, type: :string, description: 'Sort by field (id, title, author, genre)'
      parameter name: :sort_order, in: :query, type: :string, description: 'Sort order (ASC, DESC)'

      response '200', 'List of books' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   author: { type: :string },
                   genre: { type: :string }
                   # Add more properties as needed
                 },
                 required: %w[id title author genre]
               }

        run_test!
      end
    end

    post('Create book') do
      tags 'Books'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, description: 'Title' },
          author: { type: :string, description: 'Author' },
          genre: { type: :string, description: 'Genre' },
        },
        required: %w[title author genre]
      }

      response '201', 'Book created successfully' do
        run_test!
      end

      response '422', 'Invalid parameters' do
        run_test!
      end
    end
  end

  path '/api/v1/books/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Book ID'

    get('Show book') do
      tags 'Books'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Book details' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 author: { type: :string },
                 genre: { type: :string }
               },
               required: %w[id title author genre]

        run_test!
      end

      response '404', 'Book not found' do
        run_test!
      end
    end

    put('Update book') do
      tags 'Books'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, description: 'Title' },
          author: { type: :string, description: 'Author' },
          genre: { type: :string, description: 'Genre' },
        }
      }

      response '200', 'Book updated successfully' do
        run_test!
      end

      response '404', 'Book not found' do
        run_test!
      end

      response '422', 'Invalid parameters' do
        run_test!
      end
    end

    delete('Delete book') do
      tags 'Books'
      security [bearerAuth: []]

      response '204', 'Book deleted successfully' do
        run_test!
      end

      response '404', 'Book not found' do
        run_test!
      end
    end
  end

  path '/api/v1/books/search' do
    get('Search books') do
      tags 'Books'
      produces 'application/json'
      security [bearerAuth: []]

      parameter name: :query, in: :query, type: :string, description: 'Search query'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Books per page'
      parameter name: :sort_by, in: :query, type: :string, description: 'Sort by field (id, title, author, genre)'
      parameter name: :sort_order, in: :query, type: :string, description: 'Sort order (ASC, DESC)'

      response '200', 'List of books matching the search query' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   author: { type: :string },
                   genre: { type: :string }
                   # Add more properties as needed
                 },
                 required: %w[id title author genre]
               }

        run_test!
      end
    end
  end

  path '/api/v1/books/{id}/borrow' do
    parameter name: :id, in: :path, type: :integer, description: 'Book ID'

    # POST /api/v1/books/{id}/borrow
    post('Borrow book') do
      tags 'Books'
      produces 'application/json'
      security [bearerAuth: []]

      response '200', 'Book borrowed successfully' do
        run_test!
      end

      response '404', 'Book not found' do
        run_test!
      end

      response '422', 'Book already borrowed' do
        run_test!
      end
    end
  end
end
