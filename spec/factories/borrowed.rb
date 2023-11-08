# frozen_string_literal: true

FactoryBot.define do
  factory :borrowed do
    association :user
    association :book
    borrowed_at { Faker::Time.backward(days: 14) }
    returned_at { nil }

    trait :returned do
      returned_at { Faker::Time.backward(days: 7) }
    end
  end
end
