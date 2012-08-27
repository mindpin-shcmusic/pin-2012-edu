FactoryGirl.define do
  factory :course do
    sequence(:name) {|n| "fake course#{n}"}
    sequence(:cid) {|n| "course-#{n}"}
    teacher_user {FactoryGirl.create :user, :teacher}

    trait :with_student_users do
      after_create do |team|
        team.student_users = 16.times.map {FactoryGirl.create(:user, :student)}
      end
    end

  end

end
