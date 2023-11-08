# frozen_string_literal: true

json.extract! book, :id, :title, :isbn, :copies, :language, :pages, :series, :volume,
              :synopsis, :created_at, :updated_at
json.authors book.authors
json.genres book.genres
json.publishers book.publishers
json.url api_v1_book_url(book, format: :json)
