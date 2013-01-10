class AddSemesterValueToTeachingPlans < ActiveRecord::Migration
  def change
    add_column :teaching_plans, :semester_value, :string
  end
end
