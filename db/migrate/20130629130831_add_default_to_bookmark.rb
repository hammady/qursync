class AddDefaultToBookmark < ActiveRecord::Migration
  def change
    add_column :bookmarks, :is_default, :boolean, :default => false
  end
end
