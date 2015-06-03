require 'json'
require 'sinatra/base'
require 'json_encoder'
require 'windy'
require 'windy/weather_generator'

require 'yr/api_client'
require 'yr/forecast_parser'



module Windy
	class WebApp < Sinatra::Base
		include JSONEncoder
		WEATHER = WeatherGenerator.new

		get '/' do
			'hello world'
		end


		get '/test' do
			erb :example, locals: {title: 'Hello World'}
		end

		get '/data' do
      data = YR::APIClient.new.forecast(latitude: 55.6188, longitude: 12.9076)
			forecast = YR::ForecastParser.parse(data)

			json(forecast.serialize)
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


