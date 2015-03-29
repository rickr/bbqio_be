require 'sinatra'
require 'sinatra-websocket'
require 'active_record'
require 'twilio-ruby'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'bbqio_be.sqlite3'
)

set :bind, '0.0.0.0'
set :server, 'thin'
set :sockets, []

#Get your Account Sid and Auth Token from twilio.com/user/account
#account_sid = 'ACff8f06d3e47273e5b02b40590c58233f'
#auth_token = '2a9bf2cfc6bda9a2f227d388a55af0eb'

# Prod
#account_sid = 'PN7dbbd23c5ec58ec9afca9a33526faf84'
#auth_token = '7511f2d3c39b8cdbcbc71b09a5d32f10'


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
        puts "RX msg: #{msg}"
        parsed_message = nil

        begin
          parsed_message = JSON.parse(msg)
        rescue
        end

        puts parsed_message.inspect
        if(parsed_message && parsed_message.has_key?('msg'))
          begin
            account_sid = 'AC6076a757571ace25e106af671a1f175f'
            auth_token = '7511f2d3c39b8cdbcbc71b09a5d32f10'
            @twilio = Twilio::REST::Client.new account_sid, auth_token
            puts @twilio.inspect
            puts parsed_message
            puts 'RXd msg'
            message = @twilio.account.messages.create({
              :from => '+12674227748',
              :to => '4074708819',
              :body => parsed_message['msg']
            })
          rescue Exception => e
            puts 'Failed to send msg'
            puts e.inspect
          end
        end

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

