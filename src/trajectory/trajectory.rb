module NPLAB

   class CTrajectory  < CBasicJson
     
     attr_accessor :motion, :duration, :sample_rate, :trace
     
     alias up zaxis
     
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
     
     def length
       @trace.length
     end
     
     def trace_to_array()
       a = @trace.collect{|t| Utils.transf_to_hash(t)}
       return a  
     end
     
     def self.trace_from_array(a)
       trace = a.collect{|p| Utils.hash_to_transf(p)}
       return trace
     end
     
     def to_hash()
       h = {}
       h["motion"]         = @motion
       h["duration"]       = @duration
       h["sample_rate"]    = @sample_rate
       h["trace"]          = trace_to_array()
       return h
     end
     
     def self.from_hash(h)
       tr = self.new()
       tr.motion_type     = h["motion"]
       tr.duration        = h["duration"]
       tr.sample_rate     = h["sample_rate"]
       tr.trace           = trace_from_array(h["trace"])
       return tr
     end
     
     alias from_json from_hash
     alias to_json to_hash
     
   end
   
end