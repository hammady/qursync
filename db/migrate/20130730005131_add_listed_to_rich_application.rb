class AddListedToRichApplication < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :listed, :boolean, :default => false
  end
end
