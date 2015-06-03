require 'spec_helper'
require 'yr/api_client'

describe YR::APIClient do
  let(:client) { YR::APIClient.new }

  describe 'forecast' do
    let(:result) { client.forecast(latitude: 55.6188, longitude: 12.9076) }

    it 'works' do
      expect(result).to be_a(String)
    end

    it 'raises an error on bad paramaters' do
      expect{client.forecast(latitude: 'ASD', longitude: 'asdsad')}.to raise_error(YR::APIClient::Error)
    end
  end
end
