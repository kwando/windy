require 'windy/weather'

module Windy
	class WeatherGenerator
		WIND_CONDITIONS = ['calm', 'windy', 'storm']
		WIND_DIRECTIONS = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW']

		# @return [Windy::Forecast]
		def call
			Weather.new(
				wind_direction: WIND_DIRECTIONS[rand(WIND_DIRECTIONS.size)],
				wind_strength: WIND_CONDITIONS[rand(WIND_CONDITIONS.size)],
				temperature: rand * 10 + 7
				)	
		end
	end
end