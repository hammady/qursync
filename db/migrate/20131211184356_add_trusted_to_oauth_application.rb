class AddTrustedToOauthApplication < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :trusted, :boolean
  end
end
