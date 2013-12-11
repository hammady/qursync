class Api::V1::ApiController < ApplicationController
  doorkeeper_for :all, :scopes => [:read, :write]
  load_and_authorize_resource
  respond_to :json

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # GET /endpoint
  def index
    render json: resource_collection
  end

  # GET /endpoint/:id
  def show
    render json: resource_instance
  end

  # POST /endpoint
  def create
    save
  end

  # PUT /endpoint/:id
  def update
    save
  end

  # DELETE /endpoint/:id
  def destroy
    if resource_instance.destroy
      head :no_content
    else
      render json: resource_instance.errors, status: :unprocessable_entity
    end
  end

  protected

  rescue_from CanCan::AccessDenied do |exception|
    head :status => :forbidden
  end

  def save
    set_attributes(resource_instance)
    resource_instance.user = current_user if resource_instance.respond_to? "user"
    
    if resource_instance.respond_to? "pointer"
      old_pointer = resource_instance.pointer
      unless params[:page].blank?
        resource_instance.pointer = PagePointer.new page: params[:page]
      else
        unless params[:chapter].blank? || params[:verse].blank?
          resource_instance.pointer = VersePointer.new chapter: params[:chapter], verse: params[:verse]
        end      
      end
      old_pointer.destroy if resource_instance.pointer != old_pointer && resource_instance.pointer.valid? && old_pointer
    end

    success_status = resource_instance.new_record? ? :created : :ok
    if resource_instance.save
      render json: resource_instance, status: success_status
    else
      render json: resource_instance.errors, status: :unprocessable_entity
    end
  end

  private

  def resource_name
    self.class.name.split('::').last.match('(.*)Controller')[1].underscore
  end

  def resource_instance
    instance_variable_get("@#{resource_name.singularize}")
  end

  def resource_collection
    instance_variable_get("@#{resource_name.pluralize}")
  end

end
