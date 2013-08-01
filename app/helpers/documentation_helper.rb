module DocumentationHelper
  def oauth_link
    link_to "OAuth2", "http://oauth.net/2/"
  end

  def apps_link
    link_to "0 apps", oauth_applications_path
  end

  def api_base(no_http = false, no_version_path = false)
    "#{no_http ? '' : 'http://'}#{request.host_with_port}#{no_version_path ? '' : '/api/v1'}"
  end
end
