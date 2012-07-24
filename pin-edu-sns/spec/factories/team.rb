FactoryGirl.define do
  factory :team do
    sequence(:name) {|n| "fake course#{n}"}
  end
end