module NPLAB
  
  class CShootScriptGenerationConfs < CJsonObject
    attr_accessor :confs
    
    alias to_json to_array
    alias from_json from_array
    
    def initialize()
      @confs = []
    end

    def to_json
      j = []
      @confs.each{|conf|
       j << conf.to_hash
      }
      return a
    end
    
    def self.from_json(json)
      o = self.new
      json.each{|j|
        o.confs << CShootScriptGenerationConf.from_json(j)
      }
      return o
    end
    
  end
  
  class CShootScriptGenerationConf < CJsonObject
    attr_accessor :motion_type, :direction, :speed, :duration, :sample_rate
    alias to_json to_hash
    alias from_json from_hash

    def to_hash
      h = {
        "motion_type"  => @motion_type,
        "direction"    => @direction,
        "speed"        => @speed,
        "duration"     => @duration,
        "sample_rate"  => @sample_rate
      }
    end

    def self.from_hash(h)
      o = self.new()
      o.motion_type    = h["motion_type"]
      o.direction      = h["direction"]
      o.speed          = h["speed"]
      o.duration       = h["duration"]
      o.sample_rate    = h["sample_rate"]
      return o
    end
      
  end
end