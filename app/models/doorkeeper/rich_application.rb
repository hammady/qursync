module Doorkeeper
  class RichApplication < Application
    self.table_name = 'oauth_applications'

    attr_accessible :website, :description, :listed

    validates :website, presence: true
    # borrow redirect_uri validator found in <doorkeeper_gem_path>/app/validators/redirect_uri_validator.rb
    validates :website, redirect_uri: true
    validates :description, presence: true
  end
end