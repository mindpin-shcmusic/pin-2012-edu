# -*- encoding : utf-8 -*-
class AddDeadlineToHomeworks < ActiveRecord::Migration
  def change
    add_column :homeworks, :deadline, :datetime
  end
end
