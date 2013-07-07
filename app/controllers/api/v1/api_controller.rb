class Api::V1::ApiController < ApplicationController
  doorkeeper_for :all
  load_and_authorize_resource

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
