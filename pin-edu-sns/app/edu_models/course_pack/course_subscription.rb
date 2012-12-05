class CourseSubscription < ActiveRecord::Base
  belongs_to :course
  belongs_to :user

  validates :user, :presence => true
  validates :course_id, :presence => true,
    :uniqueness => {:scope => :user_id}

  module UserMethods
    def self.included(base)
      base.has_many :course_subscriptions
      base.has_many :subscribed_courses, :through => :course_subscriptions,
        :source => :course
    end

    def subscribed_course?(course)
      self.subscribed_courses.include?(course)
    end

    def subscribe_course(course)
      return if self.subscribed_courses.include?(course)
      self.course_subscriptions.create(:course => course)
    end
  end
end
