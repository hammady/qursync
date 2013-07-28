class CreatePointers < ActiveRecord::Migration
  def change
    create_table :page_pointers do |t|
      t.integer :page
      t.timestamps
    end

    create_table :verse_pointers do |t|
      t.integer :chapter
      t.integer :verse
      t.timestamps
    end
  end
end
