class ChangeSyllabusTypeInCourses < ActiveRecord::Migration
  def change
    change_column :courses, :syllabus, :text, :default => ""
  end
end
