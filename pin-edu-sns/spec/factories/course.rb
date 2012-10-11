FactoryGirl.define do
  factory :course do
    sequence(:name) {|n| "fake course#{n}"}
    sequence(:cid) {|n| "course-#{n}"}
    
    trait :with_teacher_users do
      after_create do |team|
        team.teacher_users = 16.times.map {FactoryGirl.create(:user, :teacher)}
      end
    end

  end

end
