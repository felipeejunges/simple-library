FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { '123' }
    password_confirmation { '123' }
    role { 'member' }

    trait :librarian do
      role { 'librarian' }
    end
  end
end
