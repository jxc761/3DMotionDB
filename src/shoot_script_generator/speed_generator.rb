module NPLAB
  module ShootScriptGenerator
    
    
    class CSpeedGenerator
    
      def initialize(speed)
        @intervals = []
        if speed.kind_of?(Array)
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
          speed = s_min + rand() * (s_min - s_max)
          speed.m
        }
      end
    end
    
    
  end
end