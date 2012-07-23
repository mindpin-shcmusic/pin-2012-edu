FactoryGirl.define do
  factory :teacher do
    sequence(:real_name) {|n| "fake teacher#{n}"}
  end
end