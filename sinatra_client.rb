require 'sinatra'
require 'json'
require 'typhoeus'
enable :sessions

# manually create client application details on the provider side (table: oauth2_clients)

def consumer_key
  'elmohafez'
end

def consumer_secret
  'secret_here' 
end

def request_url
  'http://localhost:3000'
end

get "/auth" do
  redirect "#{request_url}/oauth2/authorize?response_type=code&client_id=#{consumer_key}"
end

get '/callback' do
  code = request["code"]
  @message = "Successfully authenticated with the server"
  response = JSON.parse(Typhoeus.post("#{request_url}/oauth2/token", body: {
    grant_type: "authorization_code",
    code: code,
    client_id: consumer_key,
    client_secret: consumer_secret,
    redirect_uri: redirect_uri
  }).body)
  session[:access_token] = response["access_token"]
  erb :success
end

get '/bookmarks' do
  @bookmarks = get_response('bookmarks.json')
  erb :bookmarks
end

def get_response(url)
  access_token = session[:access_token]
  JSON.parse(Typhoeus.get("#{request_url}/#{url}?access_token=#{session[:access_token]}").body)
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/callback'
  uri.query = nil
  uri.to_s
end
