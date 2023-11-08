# frozen_string_literal: true

json.extract! borrowed, :id, :borrowed_at, :returned_at
json.user borrowed.user.name
json.book borrowed.book.title
json.late borrowed.late?
json.expected_return borrowed.expected_return
