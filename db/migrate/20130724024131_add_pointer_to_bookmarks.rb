class AddPointerToBookmarks < ActiveRecord::Migration
  def up
    add_column :bookmarks, :pointer_id, :integer
    add_column :bookmarks, :pointer_type, :string
    remove_column :bookmarks, [:page, :sura, :aya]
  end

  def down
    remove_column :bookmarks, :pointer_id
    remove_column :bookmarks, :pointer_type
    add_column :bookmarks, :page, :integer
    add_column :bookmarks, :sura, :integer
    add_column :bookmarks, :aya, :integer
  end
end
