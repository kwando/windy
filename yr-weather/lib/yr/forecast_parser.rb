require 'oga'
require 'yr/entities'

module YR
  class ForecastParser
    class SAXHandler
      def initialize
        @forecasts = []
        @forecast = {
            models: []
        }
      end

      attr_reader :forecasts

      def on_element(namespace, name, attributes = {})
        case name
          when 'model'
            @forecast[:models] << attributes
          when 'time'
            @location = attributes
            @location.delete('datatype')
          when 'location'
            @location.merge!(attributes)
            @inLocation = true
            @data = {}
          else
            if @inLocation
              @location[name] = attributes
            end
        end
      end

      def after_element(ns, name, attributes = {})
        case name
          when 'time'
            if @location['from'] == @location['to']
              @location['time'] = @location['from']
              @forecasts << Prediction.new(@location)
            end
          when 'location'
            @inLocation = false
        end
      end
    end
    def parse(xml_string)
      handler = SAXHandler.new
      Oga.sax_parse_xml(handler, xml_string)
      Forecast.new(@forecast, handler.forecasts)
    end

    class << self
      def parse(string)
        new.parse(string)
      end
    end
  end
end

