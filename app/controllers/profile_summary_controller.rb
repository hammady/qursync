class ProfileSummaryController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!

  def index
    endpoints = YAML.load(File.read(File.expand_path(
      '../../views/documentation/endpoints.yml', __FILE__)))
      .keys
    @counts = Hash[endpoints.zip(endpoints.map do |endpoint|
      current_user.send(endpoint).count
    end)]
    @user = current_user
    @app_gallery = Doorkeeper::RichApplication.where(:listed => true)
    @app_gallery = @app_gallery.where("id not in (?)", @user.granted_oauth_applications.map(&:id)) if @user.granted_oauth_applications.count > 0
    @demo_url = Doorkeeper::RichApplication.where("name like '%Sinatra%Demo%'").first.website
  end

  def revoke
    app = Doorkeeper::Application.find params[:app_id]
    if app
      logger.info "revoking app #{app.id}:#{app.name} for user #{current_user.id}:#{current_user.email}"
      if current_user.oauth_access_tokens.where(:application_id => app.id).destroy_all
        flash[:notice] = "Successfully revoked access to #{app.name}"
      else
        flash[:error] = "Error revoking access to #{app.name}"
      end
    end
    redirect_to '/'
  end

end
