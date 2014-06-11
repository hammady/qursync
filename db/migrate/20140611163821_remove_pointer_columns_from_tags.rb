class RemovePointerColumnsFromTags < ActiveRecord::Migration
  def up
    remove_column :tags, :pointer_id
    remove_column :tags, :pointer_type
  end

  def down
    add_column :tags, :pointer_id, :integer
    add_column :tags, :pointer_type, :string
    add_index :tags, :pointer_id
  end
end
