require 'json'
require 'sinatra/base'
require 'json_encoder'
require 'windy'
require 'windy/weather_generator'



module Windy
	class WebApp < Sinatra::Base
		include JSONEncoder
		WEATHER = WeatherGenerator.new

		get '/' do
			'hello world'
		end


		get '/test' do
			erb :index, locals: {title: 'Hello World'}
		end

		get '/style.css' do
			scss :style
		end

		get '/weather/:location' do
			weather = WEATHER.call
			json(weather.to_h.merge!(location: params[:location]))
		end	
	end
end


