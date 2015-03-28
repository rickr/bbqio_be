require 'sinatra'
require 'sinatra-websocket'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'bbqio_be.sqlite3'
)

set :bind, '0.0.0.0'
set :server, 'thin'
set :sockets, []

#
# Models
class SensorData < ActiveRecord::Base
  #create table sensor_data(id INTEGER PRIMARY KEY, timestamp INTEGER, name STRING, value FLOAT);
end

post '/sensor_data' do
  timestamp = params[:timestamp]
  name = params[:name]
  value = params[:value]
  new_data = SensorData.new(timestamp: timestamp, name: name, value: value)
  puts 'Sending to socket'
  puts params.to_json
  settings.sockets.each{|s| s.send(params.to_json)}
  params.to_json
end

get '/sensor_data' do
  if request.websocket?
    request.websocket do |ws|
      ws.onopen do
        settings.sockets << ws
      end

      ws.onmessage do |msg|
        puts msg
        EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
      end

      ws.onclose do
        warn("websocket closed")
        settings.sockets.delete(ws)
      end
    end
  else
    SensorData.all.to_json
  end
end

get '/' do
  erb :index
end

get '/dashboard' do
  erb :dashboard
end

