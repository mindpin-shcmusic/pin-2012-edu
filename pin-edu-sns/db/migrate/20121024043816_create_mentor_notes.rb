class CreateMentorNotes < ActiveRecord::Migration
  def change
    create_table :mentor_notes do |t|
      t.string :title
 
      t.timestamps
    end
  end
end
