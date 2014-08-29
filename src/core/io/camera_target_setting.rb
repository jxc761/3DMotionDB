

module NPLAB
  module CoreIO
    #
    # cameras : [camera, camera, ...]
    #   camera : {"id" : <id>, "position" : <position>}
    #     <position> : {"origin" : [x, y, z], "xaixs" : [x, y, z], "yaxis" : [x, y, z]}
    #
    # targets : [target, target, ...]
    #   target : {"id" : <id>, "position" : <position>}
    #
    # pairs : [pair, pair, ....]
    #   pair : {"camera_id" : <id>, "target_id" : <id>}
    #
    class CCameraTargetSetting < NPLAB::BasicJson::CJsonObject
      attr_accessor :cameras, :targets, :pairs
    
      def initialize(cameras, targets, pairs)
        @cameras = cameras  # cameras[i]  : CInstance
        @targets = targets  # targets[i]  : CInstance
        @pairs   = pairs    # pairs[i]    : CPair
      end

      def self.from_json(json)
        
        
        cs = json["cameras"].collect{ |camera| CCamera.from_json(camera)}
        ts = json["targets"].collect{ |target| CTarget.from_json(target)}
        ps = CPair.from_json(json["pairs"])
      
        return self.new(cs, ts, ps)
      end
    
    
      def to_json()

        cs = @cameras.collect{ |camera| camera.to_json() }
      
        ts = @targets.collect{ |target| target.to_json() }
        
        ps = @pairs.collect{|pair| pair.to_json() }

        json = {"cameras" => cs, "targets" => ts, "pairs" => ps }
        return json
      end
    
    end
    
  end
end