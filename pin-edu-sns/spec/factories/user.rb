FactoryGirl.define do
  factory :user, :aliases => [:creator, :student_user, :teacher_user, :assignee] do
    sequence(:name)  {|n| "fake#{n}"}
    sequence(:email) {|n| "fake#{n}@fake.fake"}
    password 'fake'

    trait :teacher do
      teacher
      roles_mask 4
    end

    trait :student do
      student
      roles_mask 2
    end

    trait :admin do
      name 'admin'
      roles_mask 1
      # 这里需要修改一下
    end

  end

end
