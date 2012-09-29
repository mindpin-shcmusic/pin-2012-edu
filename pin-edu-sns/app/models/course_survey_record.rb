class CourseSurveyRecord < ActiveRecord::Base
  belongs_to :course_survey

  # --- 模型关联
  belongs_to :student,
             :class_name => 'CourseSurveyRecord',
             :foreign_key => 'student_user_id'


  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :course_survey_records,
                    :class_name  => 'CourseSurveyRecord',
                    :foreign_key => :student_user_id


      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def has_surveyed?(course_survey)
        return false if course_survey.blank?
        CourseSurveyRecord.where(:student_user_id => self.id, :course_survey_id => course_survey.id).exists?
      end

      def get_course_survey_record(course_survey)
        return false if course_survey.blank?
        CourseSurveyRecord.where(:student_user_id => self.id, :course_survey_id => course_survey.id).first
      end
    end
  end

end
