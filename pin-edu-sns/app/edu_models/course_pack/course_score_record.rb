class CourseScoreRecord < ActiveRecord::Base
  belongs_to :course_score_list
  belongs_to :student_user,
             :class_name  => 'User',
             :foreign_key => :student_user_id

  attr_protected :general_score

  validates :performance_score,
            :exam_score,
            :numericality => {
              :allow_blank              => true,
              :greater_than_or_equal_to => 0,
              :less_than_or_equal_to    => 100}

  def general_score
    return nil if self.performance_score.blank? || self.exam_score.blank?
    self.performance_score * 0.3 + self.exam_score * 0.7
  end

  module UserMethods
    def self.included(base)
      base.has_many :course_score_records,
                    :foreign_key => :student_user_id
    end

  end

end
