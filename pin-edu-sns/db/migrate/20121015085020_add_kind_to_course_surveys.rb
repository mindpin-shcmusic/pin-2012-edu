class AddKindToCourseSurveys < ActiveRecord::Migration
  def change
    add_column :course_surveys, :kind, :string
  end
end
