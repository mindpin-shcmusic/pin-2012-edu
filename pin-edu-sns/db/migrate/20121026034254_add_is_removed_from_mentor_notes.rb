class AddIsRemovedFromMentorNotes < ActiveRecord::Migration
  def change
    add_column :mentor_notes, :is_removed, :boolean, :default=>false
  end
end
