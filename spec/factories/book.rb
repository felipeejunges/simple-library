# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    isbn { Faker::Code.isbn }
    copies { Faker::Number.between(from: 1, to: 10) }
    language { 'English' }
    pages { Faker::Number.between(from: 50, to: 500) }
    volume { Faker::Number.between(from: 1, to: 10) }
  end
end
