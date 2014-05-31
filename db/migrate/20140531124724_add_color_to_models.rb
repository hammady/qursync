class AddColorToModels < ActiveRecord::Migration
  def change
    add_column :bookmarks, :color, :string
    add_column :tags, :color, :string
    add_column :notes, :color, :string
  end
end
