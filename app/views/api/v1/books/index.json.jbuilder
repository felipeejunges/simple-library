# frozen_string_literal: true

json.partial! 'api/v1/shared/pagination'

json.data do
  json.array! @books, partial: 'api/v1/books/book', as: :book
end
