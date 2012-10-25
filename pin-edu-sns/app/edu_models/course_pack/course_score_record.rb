class CourseScoreRecord < ActiveRecord::Base
  belongs_to :course_score_list
  belongs_to :student_user,
             :class_name  => 'User',
             :foreign_key => :student_user_id

  module UserMethods
    def self.included(base)
      base.has_many :course_score_records,
                    :foreign_key => :student_user_id
    end

  end

end
