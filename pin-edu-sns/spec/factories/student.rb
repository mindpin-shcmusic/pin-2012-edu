FactoryGirl.define do
  factory :student do
    sequence(:real_name) {|n| "fake student#{n}"}
    sequence(:sid) {|n| "student-#{n}"}
    user
  end
end
