class CourseSurvey < ActiveRecord::Base
  has_many :course_survey_records, :dependent => :destroy 

  validates :title, :presence => true

end
