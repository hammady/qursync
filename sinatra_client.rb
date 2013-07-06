require 'sinatra'
require 'json'
require 'typhoeus'
enable :sessions

# manually create client application details on the provider side (table: oauth2_clients)

def consumer_key
  '41b5eaf89a4d1f35b91465498bf39f58f2c0a484a9dc064316967b939548528b'
end

def consumer_secret
  'd4808c6d9e9b4734c2b1c4c6267757473567ae4bac6190b251f3d7cbcabfb641' 
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
