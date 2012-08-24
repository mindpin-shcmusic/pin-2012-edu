FactoryGirl.define do
  factory :homwork do
    sequence(:title) {|n| "test homework#{n}"}
    content 'ipsum lorem....'
    creator
    course
    deadline 4.days.from_now

    trait :expired do
      deadline 4.days.ago
    end
  end
end
