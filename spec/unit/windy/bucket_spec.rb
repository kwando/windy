require 'spec_helper'
require 'windy/bucket'

describe Windy::Bucket do
  let(:tickets) { Windy::Bucket.new(1) }

  it 'has tickets available' do
    expect(tickets).to be_available
  end

  it 'has specified amount of tickets' do
    expect(tickets.tickets).to eq(1)
  end

  it 'will not be available when all tickets is used' do
    tickets = Windy::Bucket.new(1)
    expect(tickets).to be_available

    called = false
    inner_called = false
    tickets.limit {
      called = true
      expect { tickets.limit {
        inner_called = true
      } }.to raise_error(Windy::Bucket::NotTicketsError)
    }
    expect(called).to eq(true)
    expect(inner_called).to eq(false)
    expect(tickets).to be_available
  end
end