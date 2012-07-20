FactoryGirl.define do
  factory :course do
    sequence(:name) {|n| "fake course#{n}"}
  end
end