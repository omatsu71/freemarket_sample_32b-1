FactoryBot.define do

  factory :user do
    password              {"12345678"}
    password_confirmation {"12345678"}
    sequence(:email) {Faker::Internet.email}
  end

end