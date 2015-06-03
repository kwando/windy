require 'spec_helper'
require 'yr/forecast_parser'

describe 'integration' do
  DATA = File.read('spec/testdata/forecast.xml')

  describe 'parsing' do
    let(:result) { YR::ForecastParser.parse(DATA) }

    it 'returns a YR::Forecast' do
      expect(result).to be_a(YR::Forecast)
    end
  end
end
