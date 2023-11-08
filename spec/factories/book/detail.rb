FactoryBot.define do
  factory :detail do
    name { %w[author genre publisher].sample }
    description { Faker::Lorem.word }
    association :book
  end
end
