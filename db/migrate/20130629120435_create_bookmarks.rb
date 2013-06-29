class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.primary_key :id
      t.string :name
      t.integer :page
      t.integer :sura
      t.integer :aya
      t.references :user

      t.timestamps
    end
  end
end
