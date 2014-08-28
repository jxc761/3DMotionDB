module NPLAB
  module CoreIO

    class CShootScriptGenerationConf < NPLAB::BasicJson::CJsonObject
      attr_accessor :motion_type, :direction, :speed, :duration, :sample_rate

      def to_json
        h = {
          "motion_type"  => @motion_type,
          "direction"    => @direction,
          "speed"        => @speed,
          "duration"     => @duration,
          "sample_rate"  => @sample_rate
        }
      end

      def self.from_json(h)
        o = self.new()
        o.motion_type    = h["motion_type"]
        o.direction      = h["direction"]
        o.speed          = h["speed"]
        o.duration       = h["duration"]
        o.sample_rate    = h["sample_rate"]
        return o
      end
      
    end
  
    class CShootScriptGenerationConfs < NPLAB::BasicJson::CJsonObject
      attr_accessor :confs
      
      def initialize()
        @confs = []
      end

      def to_json
        j = []
        @confs.each{|conf|
         j << conf.to_json
        }
        return j
      end
    
      def self.from_json(json)
        o = self.new
        json.each{|j|
          o.confs << CShootScriptGenerationConf.from_json(j)
        }
        return o
      end
    
    end
  
  end
end