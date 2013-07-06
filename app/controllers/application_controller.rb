class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    if doorkeeper_token
      User.find(doorkeeper_token.resource_owner_id)
    #else
    #  current_user || warden.authenticate!(:scope => :user)
    end 
  end

end
