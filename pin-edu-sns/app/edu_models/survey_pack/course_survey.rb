class CourseSurvey < ActiveRecord::Base
  has_many :course_survey_records, :dependent => :destroy
  has_many :course_survey_es_records, :dependent => :destroy

  validates :title, :presence => true

  scope :with_kind, lambda {|kind| {:conditions => ['kind = ?', kind]}}

end
