# frozen_string_literal: true

json.extract! detail, :id, :name, :description
json.url book_details_url(detail, format: :json)
