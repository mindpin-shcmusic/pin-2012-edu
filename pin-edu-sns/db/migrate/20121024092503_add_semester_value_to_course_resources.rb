class AddSemesterValueToCourseResources < ActiveRecord::Migration
  def change
    add_column :course_resources, :semester_value, :string
  end
end
