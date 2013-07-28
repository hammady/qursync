class Api::V1::ApiController < ApplicationController
  doorkeeper_for :all
  load_and_authorize_resource

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  protected

  rescue_from CanCan::AccessDenied do |exception|
    head :status => :forbidden
  end

  def save(resource)
    resource.user = current_user if resource.respond_to? "user"
    
    if resource.respond_to? "pointer"
      old_pointer = resource.pointer
      unless params[:page].blank?
        resource.pointer = PagePointer.new page: params[:page]
      else
        if !params[:page].blank? && !params[:chapter].blank?
          resource.pointer = VersePointer.new chapter: params[:chapter], verse: params[:verse]
        end      
      end
      old_pointer.destroy if resource.pointer != old_pointer && resource.pointer.valid? && old_pointer
    end

    success_status = resource.new_record? ? :created : :ok
    if resource.save
      render json: resource, status: success_status
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

end
