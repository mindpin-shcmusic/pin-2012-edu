class CourseSurveyEsRecord < ActiveRecord::Base
  belongs_to :course_survey

  # --- 模型关联
  belongs_to :student,
             :class_name => 'User',
             :foreign_key => 'student_user_id'


  validates :course_survey, 
            :student, 
            :attend_class, 
            :attend_class_reason, 
            :interesting_level,
            :keywords,
            :understand_level,
            :student_question,
            :student_response,
            :presence => true


  scope :with_student, lambda {|student| {:conditions => ['student_user_id = ?', student.id]}}


  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :course_survey_es_records,
                    :class_name  => 'CourseSurveyEsRecord',
                    :foreign_key => :student_user_id


      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def has_surveyed?(course_survey)
        return false if course_survey.blank?
        
        case course_survey.kind
        when '1'
          CourseSurveyRecord.where(:student_user_id => self.id, :course_survey_id => course_survey.id).exists?
        when '2'
          CourseSurveyEsRecord.where(:student_user_id => self.id, :course_survey_id => course_survey.id).exists?
        end
      end
    end
  end

end

