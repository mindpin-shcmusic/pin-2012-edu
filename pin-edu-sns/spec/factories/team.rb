FactoryGirl.define do
  factory :team do
    sequence(:name) {|n| "fake course#{n}"}
    sequence(:cid) {|n| "course-#{n}"}
    teacher_user

    trait :with_student_users do
      after_create do |team|
        team.student_users = 16.times.map {FactoryGirl.create(:user, :student)}
      end
    end

  end

end
