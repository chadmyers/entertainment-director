require 'sinatra'
require 'erb'

things_to_do = [  "Ride bikes",
                  "Read a book",
                  "Draw",
                  "Color",
                  "Cards",
                  "Origami",
                  "Trampoline",
                  "Legos"
               ]

class Array
  # If +number+ is greater than the size of the array, the method
  # will simply return the array itself sorted randomly
  def randomly_pick(number)
    sort_by{ rand }.slice(0...number)
  end
end

configure do
#  require 'redis'
#  redisUri = ENV["REDISTOGO_URL"] || 'redis://localhost:6379'
#  uri = URI.parse(redisUri)
#  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/' do
  @activity = things_to_do.randomly_pick(1)[0]
  erb :index
end
