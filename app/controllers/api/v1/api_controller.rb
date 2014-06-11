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
    unless conflict?
      save
    else
      render status: :conflict, json: resource_instance
    end
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
    # cache resource_instance call
    instance = resource_instance

    # set attributes in children
    set_attributes(instance)
    # attach to current user, to overcome user injection attacks
    instance.user = current_user if instance.respond_to? "user"
    
    if instance.respond_to? "pointer"
      old_pointer = instance.pointer
      params_pointer = params[:pointer]
      unless params_pointer.blank?
        params[:page] = params_pointer[:page] unless params_pointer[:page].blank?
        params[:chapter] = params_pointer[:chapter] unless params_pointer[:chapter].blank?
        params[:verse] = params_pointer[:verse] unless params_pointer[:verse].blank?
      end
      unless params[:page].blank?
        instance.pointer = PagePointer.new page: params[:page]
      else
        unless params[:chapter].blank? || params[:verse].blank?
          instance.pointer = VersePointer.new chapter: params[:chapter], verse: params[:verse]
        end      
      end
      old_pointer.destroy if instance.pointer != old_pointer && instance.pointer.valid? && old_pointer
    end

    success_status = instance.new_record? ? :created : :ok
    if instance.save
      render json: instance, status: success_status
    else
      render json: instance.errors, status: :unprocessable_entity
    end
  end

  def conflict?
    params[:etag] != resource_instance.etag
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
