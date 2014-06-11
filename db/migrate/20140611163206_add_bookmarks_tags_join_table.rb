class AddBookmarksTagsJoinTable < ActiveRecord::Migration
  def change
    create_table :bookmarks_tags do |t|
      t.references :bookmark
      t.references :tag
    end
    add_index :bookmarks_tags, :bookmark_id
    add_index :bookmarks_tags, :tag_id
  end
end
