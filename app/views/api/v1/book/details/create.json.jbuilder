# frozen_string_literal: true

json.extract! @detail, :id, :name, :description
json.url api_v1_book_detail_url(book_id: @detail.book_id, id: @detail.id, format: :json)
