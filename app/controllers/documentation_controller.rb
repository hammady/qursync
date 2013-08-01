class DocumentationController < ApplicationController
  def getting_started
    @presentation_url = "http://www.slideshare.net/briandavidcampbell/is-that-a-token-in-your-phone-in-your-pocket-or-are-you-just-glad-to-see-me-oauth-20-and-mobile-devices"
    @endpoints_count = endpoints.keys.count
  end

  def api_reference
    endpoint = params[:endpoint]
    if endpoint
      @endpoint_name = endpoint
      @endpoint_params = endpoints[endpoint]
      unless @endpoint_params
        flash[:error] = "Endpoint #{endpoint} not found in the API reference"
        redirect_to api_reference_path
      end
    else
      @endpoints = endpoints.keys
    end
  end

  private

  def endpoints
    YAML.load(File.read(File.expand_path('../../views/documentation/endpoints.yml', __FILE__)))
  end
end
