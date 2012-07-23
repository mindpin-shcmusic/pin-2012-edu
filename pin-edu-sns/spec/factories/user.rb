FactoryGirl.define do
  factory :user do
    sequence(:name)  {|n| "fake#{n}"}
    sequence(:email) {|n| "fake#{n}@fake.fake"}
    password 'fake'
  end
end