FactoryGirl.define do
  factory :user, :aliases => [:creator, :student_user, :teacher_user, :assignee] do
    sequence(:name)  {|n| "fake#{n}"}
    sequence(:email) {|n| "fake#{n}@fake.fake"}
    password 'fake'

    trait :teacher do
      teacher
    end

    trait :student do
      student
    end

    trait :admin do
      id 1
      name 'admin'
      # 这里需要修改一下
    end

  end

end
