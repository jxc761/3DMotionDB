module NPLAB

  module CoreIO
    # motion     : string
    # duration   : int
    # sample_rate: int
    # trace      : array
    # trace[i]   : Transformation
    class CTrajectory  < NPLAB::BasicJson::CJsonObject
     
      attr_accessor :motion_info, :duration, :sample_rate, :trace
      def initialize(m, d, sr, tr)
        @motion_info = m
        @duration  = d
        @sample_rate = sr
        @trace = tr
        
      end
      def position(id)
        return trace[id]
      end
     
      def location(id)
        return position(id).origin
      end
      def xaxis(id)
        return position(id).xaxis
      end
     
      def yaxis(id)
        return position(id).yaxis
      end
     
      def zaxis(id)
        return position(id).zaxis
      end
      alias_method :up, :zaxis
       
      def length
        @trace.length
      end
       
     
      def to_json()
        json = {}
        json["motion_info"]    = @motion_info
        json["duration"]       = @duration
        json["sample_rate"]    = @sample_rate
        json["trace"]          = @trace.collect{|position| Utils.transf_to_hash(position)}
        return json
      end
     
      def self.from_json(json)
        m  = json["motion_info"]
        d  = json["duration"]
        sr = json["sample_rate"]
        tr = json["trace"].collect{|position| Utils.hash_to_transf(position)}
        return self.new(m, d, sr, tr)
      end
     
    end
   
  end
end