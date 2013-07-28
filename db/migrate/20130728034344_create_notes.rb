class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :text
      t.references :user
      t.references :pointer, polymorphic: true

      t.timestamps
    end
    add_index :notes, :user_id
    add_index :notes, :pointer_id
  end
end
