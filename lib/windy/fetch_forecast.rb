module Windy
  class FetchForecast
    Error = Class.new(StandardError)
    def initialize(retry_timeout: 5, concurrency: 1)
      @circuit = Windy::Circuit.new(timeout: retry_timeout)
      @pool = Bucket.new(concurrency)
    end

    def call(latitude:, longitude:)
      data = @pool.limit { @circuit.use { YR::APIClient.new.forecast(latitude: latitude, longitude: longitude) } }
      forecast = YR::ForecastParser.parse(data)
      forecast
    rescue => ex
      Error.new(ex)
    end
  end
end
