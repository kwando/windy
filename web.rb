require 'json'
require 'sinatra/base'
require 'json_encoder'
require 'windy'
require 'windy/weather_generator'
require 'windy/bucket'
require 'windy/circuit'

require 'yr/api_client'
require 'yr/forecast_parser'

require 'tilt/erb'
require 'tilt/sass'
require 'lru_redux'

module Windy
  class WebApp < Sinatra::Base
    include JSONEncoder
    WEATHER = WeatherGenerator.new

    get '/' do
      erb :index
    end

    get '/test' do
      sleep rand
      erb :example, locals: {title: 'Hello World'}
    end

    Cache = LruRedux::TTL::ThreadSafeCache.new(100, 5 * 60)
    require 'windy/fetch_forecast'
    get '/data' do
      begin
        data = Cache.getset('forecast'){
          forecast = FetchForecast.new.call(latitude: 55.6188, longitude: 12.9076)
          forecast.serialize
        }

        json(data)
      rescue Windy::FetchForecast::Error => ex
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
