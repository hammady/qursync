class AddDeveloperToUser < ActiveRecord::Migration
  def change
    add_column :users, :developer_since, :date
  end
end
