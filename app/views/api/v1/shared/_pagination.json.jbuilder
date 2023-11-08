# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :page, :items, :next, :count, :pages, :prev_url, :next_url, :first_url, :last_url
end
