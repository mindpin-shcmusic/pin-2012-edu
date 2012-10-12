FactoryGirl.define do
  factory :teaching_plan do
    sequence(:title) {|n| "teaching_plan#{n}"}
  end
end