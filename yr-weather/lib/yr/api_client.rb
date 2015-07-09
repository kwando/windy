require 'hurley'

module YR
  class APIClient
    Error = Class.new(StandardError)
    class HTTPError < Error
      def initialize(message, status_code, response)
        super(message)
        @status_code = status_code
        @response = response
      end
      attr_reader :status_code
      attr_reader :response
    end

    def initialize
      @http = Hurley::Client.new('http://api.yr.no')
      @http.request_options.timeout = 0.5
    end

    # Get weather forecast data from YR
    #
    # Docs: http://api.yr.no/weatherapi/locationforecast/1.9/documentation
    #
    # Example URL: http://api.yr.no/weatherapi/locationforecast/1.9/?lat=60.10;lon=9.58;msl=70
    def forecast(latitude:, longitude:, msl: 2)
      response = @http.get('/weatherapi/locationforecast/1.9/', lat: latitude, lon: longitude, msl: msl)
      return response.body if response.success?

      raise HTTPError.new("could not fetch forecast data, got status #{response.status_code}:\n" << response.body, response.status_code, response)
    rescue Hurley::ConnectionFailed => ex
      raise Error.new(ex.message)
    end
  end
end
