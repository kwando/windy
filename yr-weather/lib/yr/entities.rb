require 'virtus'

module YR
  Entity = Virtus.value_object
  class Temperature
    include Entity
    values do
      attribute :unit, String
      attribute :value, Float
    end

    def to_s
      "#{value} C"
    end
  end
  class WindSpeed
    include Entity
    values do
      attribute :mps, Float
      attribute :beaufort, Integer
      attribute :name, String
    end

    def to_s
      "#{mps} m/s"
    end
  end
  class Pressure
    include Entity
    values do
      attribute :value, Float
      attribute :unit, String
    end

    def to_s
      "#{value} #{unit}"
    end
  end
  class Cloudiness
    include Entity

    values do
      attribute :percent, Float
    end

    def to_s
      percent.to_s << '%'
    end
  end
  class WindDirection
    include Entity

    values do
      attribute :deg, Float
      attribute :name, String
    end

    def to_s
      "#{name}"
    end
  end

  class Prediction
    include Entity

    values do
      attribute :time, Time
      attribute :latitude, Float
      attribute :longitude, Float
      attribute :temperature, Temperature
      attribute :windSpeed, WindSpeed
      attribute :windDirection, WindDirection
      attribute :cloudiness, Cloudiness
      attribute :pressure, Pressure
    end

    def date
      from.to_date
    end

    def to_h
      super.tap do |hash|
        hash.each { |k, v| hash[k] = v.to_h if v.respond_to?(:to_h) }
      end
    end

    def to_s
      "#{from.strftime('%Y-%m-%d %H%M')}, #{temperature}, #{windSpeed} #{windDirection}, #{cloudiness}, #{pressure}"
    end
  end

  class Forecast
    def initialize(attributes, predictions)
      @attributes = attributes
      @predictions = predictions
    end

    def first
      @predictions.first
    end

    def at(time)
      @predictions.detect { |p| p.time > time }
    end

    def each(&block)
      @predictions.each(&block)
    end

    def serialize
      @predictions.map(&:to_h)
    end
  end
end
