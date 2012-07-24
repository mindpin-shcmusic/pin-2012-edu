class ChangeAchievementShareRateDefault < ActiveRecord::Migration
  def change
    change_column :achievements, :share_rate, :float, :default => 0.0
  end
end
