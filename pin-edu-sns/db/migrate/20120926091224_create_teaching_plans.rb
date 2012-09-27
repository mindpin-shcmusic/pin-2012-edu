class CreateTeachingPlans < ActiveRecord::Migration
  def change
    create_table :teaching_plans do |t|
      t.string :title
      t.timestamps
    end
  end
end
