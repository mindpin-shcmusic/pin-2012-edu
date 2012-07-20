FactoryGirl.define do
  factory :student do
    sequence(:real_name) {|n| "fake student#{n}"}
  end
end