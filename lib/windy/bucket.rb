require 'thread'

module Windy
  class Bucket
    Error = Class.new(StandardError)
    NotTicketsError = Class.new(Error)

    def initialize(tickets)
      @tickets = tickets
      @used = 0
      @mutex = Mutex.new
    end

    def available?
      @used < @tickets
    end

    attr_reader :tickets

    def limit
      checkout!
      begin
        yield
      ensure
        checkin
      end
    end

    private
    def checkin
      @mutex.synchronize do
        if @used <= 0
          raise Error.new('cannot check in more tickets')
        end
        @used -= 1
      end
      self
    end

    def checkout
      result = false
      @mutex.synchronize do
        if available?
          @used += 1
          result = true
        end
      end
      result
    end

    def checkout!
      result = checkout()
      unless result
        raise NotTicketsError.new('no tickets left')
      end
      result
    end
  end
end