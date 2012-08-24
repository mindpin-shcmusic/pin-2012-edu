FactoryGirl.define do
  factory :teacher do
    sequence(:real_name) {|n| "fake teacher#{n}"}
    sequence(:tid) {|n| "teacher-#{n}"}
    user
  end
end
