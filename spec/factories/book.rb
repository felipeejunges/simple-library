FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    isbn { Faker::Code.isbn }
    copies { Faker::Number.between(from: 1, to: 10) }
    language { Faker::Book.language }
    pages { Faker::Number.between(from: 50, to: 500) }
    series { Faker::Book.series }
    volume { Faker::Number.between(from: 1, to: 10) }
  end
end
