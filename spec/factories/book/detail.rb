FactoryBot.define do
  factory :book_detail, class: 'Book::Detail' do
    name { 'author' } # Default name, change as needed
    description { 'Sample description' } # Default description, change as needed
    association :book, factory: :book # Assumes you have a factory for Book model named :book
  end
end