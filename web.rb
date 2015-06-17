require 'json'
require 'sinatra/base'
require 'json_encoder'
require 'windy'
require 'windy/weather_generator'

require 'yr/api_client'
require 'yr/forecast_parser'

require 'tilt/erb'
require 'tilt/sass'

module Windy
	class WebApp < Sinatra::Base
		include JSONEncoder
		WEATHER = WeatherGenerator.new

		get '/' do
			erb :index
		end


		get '/test' do
			erb :example, locals: {title: 'Hello World'}
		end

    get '/data' do
      begin
        data = YR::APIClient.new.forecast(latitude: 55.6188, longitude: 12.9076)
        forecast = YR::ForecastParser.parse(data)

        json(forecast.serialize)
      rescue YR::APIClient::HTTPError => ex
        json({error: ex.message}, status: 503)
      end
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


