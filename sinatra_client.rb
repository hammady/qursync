require 'sinatra'
require 'json'
require 'typhoeus'
enable :sessions

# manually create client application details on the provider side (table: oauth2_clients)

def consumer_key
  '2711218e75b9bad861c3fe0a149b8f9a964f8e427d36c8c70250d630c7d045f8'
end

def consumer_secret
  'd645f616a397f90606ab6dc0f4e3104c023eb25945059c6ba06c56e75dfe077c' 
end

def request_url
  'http://localhost:3000'
end

get "/auth" do
  redirect "#{request_url}/oauth/authorize?client_id=#{consumer_key}&redirect_uri=http%3A%2F%2Flocalhost%3A4567%2Fcallback&response_type=code"
end

get '/callback' do
  code = request["code"]
  if code
    @message = "Successfully authenticated with the server"
    response = JSON.parse(Typhoeus.post("#{request_url}/oauth/token", body: {
      grant_type: "authorization_code",
      code: code,
      client_id: consumer_key,
      client_secret: consumer_secret,
      redirect_uri: redirect_uri
    }).body)
    session[:access_token] = response["access_token"]
  else
    @message = "Error authenticating with the server"
  end
  @success = !!code
  erb :success
end

get '/bookmarks' do
  @bookmarks = get_response('bookmarks')
  erb :bookmarks
end

def get_response(url)
  access_token = session[:access_token]
  JSON.parse(Typhoeus.get("#{request_url}/api/v1/#{url}?access_token=#{session[:access_token]}").body)
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/callback'
  uri.query = nil
  uri.to_s
end
