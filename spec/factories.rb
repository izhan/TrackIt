FactoryGirl.define do
  factory :user do
    sequence(:first_name)  { |n| "FirstName #{n}" }
    sequence(:last_name)  { |n| "LastName #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar123"
    password_confirmation "foobar123"
    confirmed_at Time.now()
  end
end
