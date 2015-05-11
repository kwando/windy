module Windy
	class Weather
		def initialize(wind_strength:, wind_direction:, temperature:)
			@wind_strength, @wind_direction, @temperature = wind_direction, wind_strength, temperature
		end

		attr_reader :wind_strength
		attr_reader :wind_direction
		attr_reader :temperature

		def to_h
			{
				wind_direction: wind_direction,
				wind_strength: wind_strength,
				temperature: temperature
			}
		end			
	end
end