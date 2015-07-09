require 'spec_helper'
require 'windy/circuit'

describe Windy::Circuit do
  context 'integration' do
    let(:clock) {
      Struct.new(:now).new(Time.now.to_i)
    }
    let(:circuit) {
      Windy::Circuit.new(timeout: 1, clock: clock)
    }

    def step_time(delta = 1)
      clock.now += delta
    end

    def trigger_circuit
      begin
        circuit.use { raise 'error' }
      rescue
      end
      circuit
    end

    it 'calls the block' do
      called = false
      result = circuit.use { called = true;Math::PI }
      expect(called).to eq(true)
      expect(result).to eq(Math::PI)
    end

    it 'does not call block' do
      called = false

      trigger_circuit

      expect(circuit).not_to be_open

      expect { circuit.use { called = true } }.to raise_error(Windy::Circuit::Error)
      expect(called).to eq(false)
    end

    context 'reopening' do
      it 'reopens if the test passes' do
        trigger_circuit
        expect(circuit).not_to be_open

        step_time(2)

        called = false
        result = circuit.use { called = true; Math::PI }
        expect(called).to eq(true)
        expect(circuit).to be_open
        expect(result).to eq(Math::PI)
      end
    end
  end
end