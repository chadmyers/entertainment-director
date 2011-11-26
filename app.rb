require 'sinatra'
require 'erb'
require 'json'

class Array
  # If +number+ is greater than the size of the array, the method
  # will simply return the array itself sorted randomly
  def randomly_pick(number)
    sort_by{ rand }.slice(0...number)
  end
end

configure do
  require 'redis'
  redisUri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
  uri = URI.parse(redisUri)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/clear' do
  REDIS.set("things_to_do", "[]")
  redirect '/'
end

get '/' do
  json = REDIS.get("things_to_do") || "[]"
  things_to_do = JSON.parse(json)
  @activity = things_to_do.randomly_pick(1)[0]
  erb :index
end

post '/add' do
  activity = params[:activity]
  json = REDIS.get("things_to_do") || "[]"
  things_to_do = JSON.parse(json)
  things_to_do.push(activity)
  new_json = JSON.generate things_to_do
  REDIS.set("things_to_do", things_to_do)
  redirect '/'
end

get '/list' do
  json = REDIS.get("things_to_do") || "[]"
  @things_to_do = JSON.parse(json)
  erb :list
end
