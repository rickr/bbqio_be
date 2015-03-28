require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'bbqio_be.sqlite3'
)


#
# Models
class SensorData < ActiveRecord::Base
  #create table sensor_data(id INTEGER PRIMARY KEY, timestamp INTEGER, name STRING, value FLOAT);
end

post '/sensor_data' do
  timestamp = params[:timestamp]
  name = params[:name]
  value = params[:value]
  new_data = SensorData.create(timestamp: timestamp, name: name, value: value)
  new_data.to_json
end

get '/sensor_data' do
  SensorData.all.to_json
end

