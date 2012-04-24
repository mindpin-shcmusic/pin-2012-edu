# -*- encoding : utf-8 -*-
class ChangeCreatorIdFromHomeworkAssigns < ActiveRecord::Migration
  def change
    rename_column :homework_assigns, :creator_id, :student_id
  end
end
