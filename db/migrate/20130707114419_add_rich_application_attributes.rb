class AddRichApplicationAttributes < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :website, :string
    add_column :oauth_applications, :description, :text
  end
end
