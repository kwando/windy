module Windy
  class Circuit
    class Clock
      def now
        Time.now.to_i
      end
    end

    def initialize(timeout: 10, clock: Clock.new)
      @open = true
      @closed_at = 0
      @clock = clock
      @timeout = timeout

      @testing = false
      @mutex = Mutex.new
    end

    def open?
      @open
    end

    Error = Class.new(StandardError)

    def use
      if @open
        yield
      elsif timeout_passed? && !@testing
        puts 'testing circuit backend'
        @testing = true
        yield.tap {
          @mutex.synchronize {
            @testing = false
            @open = true
          }
          puts 'circuit reopened'
        }
      else
        STDERR.puts 'circuit is closed, raising exception'
        raise Error.new('circuit closed')
      end
    rescue Error => ex
      raise ex
    rescue Exception => ex
      STDERR.puts ex.class, ex.message
      @mutex.synchronize {
        @closed_at = @clock.now
        @testing = false
        @open = false
      }

      STDERR.puts 'circuit closed'
      raise ex
    end

    private
    def timeout_passed?
      @closed_at + @timeout < @clock.now
    end
  end
end