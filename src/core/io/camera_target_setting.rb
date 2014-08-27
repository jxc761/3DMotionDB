

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
    class CCameraTargetSetting < CJsonObject
      attr_accessor :cameras, :targets, :pairs
    
      def initialize(cameras, targets, pairs)
        @cameras = cameras  # cameras[i]  : CInstance
        @targets = targets  # targets[i]  : CInstance
        @pairs   = pairs    # pairs[i]    : pair
      end

      def self.from_json(json)
        cameras = json["cameras"].each{ |camera| CCamera.from_json(camera)}
        targets = json["targets"].each{ |target| CTarget.from_json(target)}
        pairs   = CPair.from_json(json["pairs"])
      
        return self.new(cameras, targets, pairs)
      end
    
    
      def to_json()
        cameras = @cameras.each{ |camera| camera.to_json() }
      
        targets = @targets.each{ |target| target.to_json() }
        
        pairs   = @pairs.to_json()
        
        json = {"cameras" => cameras, "targets" => targets, "pairs" => pairs }
      
        return json
      end
    
    end
    
  end
end