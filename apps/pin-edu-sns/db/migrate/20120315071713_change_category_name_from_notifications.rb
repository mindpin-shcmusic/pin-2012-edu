class ChangeCategoryNameFromNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :category, :kind
  end
end
