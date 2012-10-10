class CreateCourseSurveys < ActiveRecord::Migration
  def change
    create_table :course_surveys do |t|
      t.integer :title

      t.timestamps
    end
  end
end
