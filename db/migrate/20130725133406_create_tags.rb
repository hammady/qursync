class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :tag_name
      t.references :pointer, polymorphic: true

      t.timestamps
    end
    add_index :tags, :tag_name_id
    add_index :tags, :pointer_id
  end
end
