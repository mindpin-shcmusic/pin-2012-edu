class AddKindToHomework < ActiveRecord::Migration
  def change
    add_column :homeworks, :kind, :string
  end
end
