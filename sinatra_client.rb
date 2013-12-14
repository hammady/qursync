require 'sinatra'
require 'json'
require 'typhoeus'
require 'sinatra/flash'
enable :sessions

# manually create client application details on the provider side (table: oauth2_clients)

CONSUMER_KEY = '51ae32d245f7b8fe2b3bee7ed54b05bb9968cd8c879ceced8421841dc9fb7d76'
CONSUMER_SECRET = '5d2e8ccf0bd14aa13371752da84cd36f50e5be837b8dc5730248daf6059ba1b1' 
REQUEST_URL = 'http://localhost:3000'

HUMAN_CODES = {

}

ENDPOINTS = %w(bookmarks tag_names tags notes)

ENDPOINT_PARAMS = {
  :bookmarks => %w(name page chapter verse is_default),
  :tag_names => %w(name),
  :tags => %w(tag_name_id page chapter verse),
  :notes => %w(text page chapter verse)
}

ENDPOINT_PARAMS_READONLY = {
  :tags => %w(tag_name_id)
}

ENDPOINT_PARAMS_HINTS = {
  :bookmarks => "either type a page number or a combination of chapter/verse, set is_default to 1 to mark it as the default bookmark (e.g. last page)",
  :tag_names => "name is mandatory",
  :tags => "get tag_name_id from tag_names endpoint, either type a page number or a combination of chapter/verse",
  :notes => "write a long text here, either type a page number or a combination of chapter/verse"
}

# begin sinatra handlers

get '/' do
  if session[:access_token]
    @endpoints = ENDPOINTS
    erb :home
  else
    redirect '/auth'
  end
end

get "/auth" do
  redirect "#{REQUEST_URL}/oauth/authorize?client_id=#{CONSUMER_KEY}&redirect_uri=#{redirect_uri}&response_type=code"
end

get '/callback' do
  code = request["code"]
  if code
    @message = "Successfully authenticated with the server"
    response = JSON.parse(Typhoeus.post("#{REQUEST_URL}/oauth/token", body: {
      grant_type: "authorization_code",
      code: code,
      client_id: CONSUMER_KEY,
      client_secret: CONSUMER_SECRET,
      redirect_uri: redirect_uri
    }).body)
    session[:access_token] = response["access_token"]
  else
    @message = "Error authenticating with the server"
  end
  @endpoints = !!code ? ENDPOINTS : [] 
  erb :home
end

get '/demo/:endpoint' do
  endpoint = params[:endpoint]
  if ENDPOINTS.include?(endpoint)
    url = "#{REQUEST_URL}/api/v1/#{endpoint}?access_token=#{session[:access_token]}"
    response = Typhoeus.get(url)
    code, @content = parse_response(response)
    @endpoint = endpoint
    @inputs = ENDPOINT_PARAMS[endpoint.to_sym]
    @readonly_inputs = ENDPOINT_PARAMS_READONLY[endpoint.to_sym] || []
    @REQUEST_URL = "#{REQUEST_URL}/api/v1"
    @hint = ENDPOINT_PARAMS_HINTS[endpoint.to_sym]
    erb :content
  else
    flash[:error] = "There is no endpoint called '#{endpoint}'"
    redirect '/'
  end
end

post '/demo/modify' do
  action = params[:action]
  id = params[:id]
  endpoint = params[:endpoint].to_sym
  method, url, operation = :get, endpoint, ""
  case action
  when 'update'
    url = "#{endpoint}/#{id}"
    method = :put
    operation = "Updating"
  when 'create'
    url = endpoint
    method = :post
    operation = "Creating"
  when 'delete'
    url = "#{endpoint}/#{id}"
    method = :delete
    operation = "Deleting"
  end
  url = "#{REQUEST_URL}/api/v1/#{url}?access_token=#{session[:access_token]}" 
  phash = Hash[
    ENDPOINT_PARAMS[endpoint].zip ENDPOINT_PARAMS[endpoint].map{|p| params[p]}
  ]
  phash[:etag] = params[:etag]
  request = Typhoeus::Request.new(url, method: method, params: phash)
  request.run
  parse_response(request.response, operation)

  redirect "/demo/#{endpoint}"
end

private

def parse_response(response, flash_operation = nil)
  code = response.code
  body = JSON.parse(response.body) rescue "NO JSON BODY"

  if code == 401
    redirect '/auth'
  elsif flash_operation
    flash[code.between?(200, 299) ? :notice : :error] = "#{flash_operation} (#{code} #{response.status_message.strip}) - #{body == '' ? '[NO BODY]' : body}"
  end
  return code, body
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/callback'
  uri.query = nil
  uri.to_s
end
