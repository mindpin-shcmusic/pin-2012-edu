# -*- encoding : utf-8 -*-
class AddHasFinishedToHomeworkAssigns < ActiveRecord::Migration
  def change
    add_column :homework_assigns, :has_finished, :boolean, :default => 0
  end
end
