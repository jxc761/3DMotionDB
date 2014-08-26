module NPLAB
  class CSpeedGenerator
    
    def initialize(speed)
      @intervals = []
      if speeds.kind_of?(Array)
        @intervals = speed
      else
        @intervals = [speed, speed]
      end
    end

    def generate_speeds()
      nIntervals = @intervals.size
      speeds = (1...nIntervals).collect{ |i|
        s_min = @intervals[i-1]
        s_max = @intervals[i]
        smin + rand() * (s_min - s_max)
      }
    end
    
  end
end