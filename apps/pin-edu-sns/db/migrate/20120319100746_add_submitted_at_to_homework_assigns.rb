# -*- encoding : utf-8 -*-
class AddSubmittedAtToHomeworkAssigns < ActiveRecord::Migration
  def change
    add_column :homework_assigns, :submitted_at, :datetime
  end
end
