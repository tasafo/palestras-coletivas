FactoryGirl.define do
  factory :user do
    name "Paul Young"
    sequence(:email) { |i| "paul#{i}@example.org" }
    password "test"
    password_confirmation "test"
  end
end