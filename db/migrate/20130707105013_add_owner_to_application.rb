class AddOwnerToApplication < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :owner_id, :integer, :null => false
    add_column :oauth_applications, :owner_type, :string, :null => false
    add_index :oauth_applications, [:owner_id, :owner_type]
  end
end