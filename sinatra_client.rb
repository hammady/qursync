require 'sinatra'
require 'json'
require 'typhoeus'
require 'sinatra/flash'
enable :sessions

# manually create client application details on the provider side (table: oauth2_clients)

def consumer_key
  '51ae32d245f7b8fe2b3bee7ed54b05bb9968cd8c879ceced8421841dc9fb7d76'
end

def consumer_secret
  '5d2e8ccf0bd14aa13371752da84cd36f50e5be837b8dc5730248daf6059ba1b1' 
end

def request_url
  'http://localhost:3000'
end

def endpoints
  %w(bookmarks tag_names tags notes)
end

def endpoint_params
  {
    :bookmarks => %w(name page chapter verse is_default),
    :tag_names => %w(name),
    :tags => %w(tag_name_id page chapter verse),
    :notes => %w(text page chapter verse)
  }
end

def endpoint_params_readonly
  {
    :tags => %w(tag_name_id)
  }
end

def endpoint_params_hints
  {
    :bookmarks => "either type a page number or a combination of chapter/verse, set is_default to 1 to mark it as the default bookmark (e.g. last page)",
    :tag_names => "name is mandatory",
    :tags => "get tag_name_id from tag_names endpoint, either type a page number or a combination of chapter/verse",
    :notes => "write a long text here, either type a page number or a combination of chapter/verse"
  }
end

get '/' do
  if session[:access_token]
    @endpoints = endpoints
    erb :home
  else
    redirect '/auth'
  end
end

get "/auth" do
  redirect "#{request_url}/oauth/authorize?client_id=#{consumer_key}&redirect_uri=#{redirect_uri}&response_type=code"
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
  @endpoints = !!code ? endpoints : [] 
  erb :home
end

get '/demo/:endpoint' do
  endpoint = params[:endpoint]
  if endpoints.include?(endpoint)
    url = "#{request_url}/api/v1/#{endpoint}?access_token=#{session[:access_token]}"
    response = Typhoeus.get(url)
    code, @content = parse_response(response, "Listing", false)
    @endpoint = endpoint
    @inputs = endpoint_params[endpoint.to_sym]
    @readonly_inputs = endpoint_params_readonly[endpoint.to_sym] || []
    @request_url = "#{request_url}/api/v1"
    @hint = endpoint_params_hints[endpoint.to_sym]
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
  url = "#{request_url}/api/v1/#{url}?access_token=#{session[:access_token]}" 
  phash = Hash[
    endpoint_params[endpoint].zip endpoint_params[endpoint].map{|p| params[p]}
  ]
  request = Typhoeus::Request.new(url, method: method, params: phash)
  request.run
  parse_response(request.response, operation, true)

  redirect "/demo/#{endpoint}"
end

def parse_response(response, operation_name, body_in_flash)
  body = JSON.parse(response.body) rescue ""
  code = response.code
  type = code.between?(200, 299) ? :notice : :error

  if code == 401
    redirect '/auth'
  else
    message = "#{operation_name} #{code}"
    message = "#{message} #{body == '' ? '[NO BODY]' : body}" if body_in_flash
    flash[type] = message
    return code, body
  end
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/callback'
  uri.query = nil
  uri.to_s
end
