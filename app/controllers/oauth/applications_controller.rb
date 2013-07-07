class Oauth::ApplicationsController < Doorkeeper::ApplicationController

  respond_to :html

  before_filter :authenticate_user!
  load_and_authorize_resource :class => "Doorkeeper::RichApplication"

  def create
    @application.owner = current_user

    if @application.save
      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :create])
      respond_with [:oauth, @application]
    else
      flash[:error] = "Error creating application"
      render :new
    end
  end

  def update
    @application.owner = current_user
    if @application.update_attributes(params[:application])
      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :update])
      respond_with [:oauth, @application]
    else
      render :edit
    end
  end

  def destroy
    flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :destroy]) if @application.destroy
    redirect_to oauth_applications_url
  end
end
