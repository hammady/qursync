class DocumentationController < ApplicationController
  def ping
    render text: "OK"
  end
  
  def getting_started
    load_endpoints
    @presentation_url = "http://www.slideshare.net/briandavidcampbell/is-that-a-token-in-your-phone-in-your-pocket-or-are-you-just-glad-to-see-me-oauth-20-and-mobile-devices"
    @endpoints_count = @endpoints.count
  end

  def api_reference
    load_endpoints
  end

  def client_interfaces
    load_endpoints
    if @endpoint_name
      code = render_to_string(partial: 'java_interface', locals: {resource: @endpoint_name.singularize})
      @html = CodeRay.scan(code, :java).div
    end
  end

  private

  def load_endpoints
    endpoints = YAML.load(File.read(File.expand_path('../../views/documentation/endpoints.yml', __FILE__)))
    endpoint = params[:endpoint]
    if endpoint
      @endpoint_name = endpoint
      @json_hints = endpoints[endpoint].delete "json_hints"
      @endpoint_params = endpoints[endpoint]
      unless @endpoint_params
        flash[:error] = "Endpoint #{endpoint} not found in the API reference"
        redirect_to documentation_path
      end
    else
      @endpoints = endpoints.keys
    end
  end
end
