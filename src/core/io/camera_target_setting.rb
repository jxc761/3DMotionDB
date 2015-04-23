

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
        ps = json["pairs"].collect{|pair| CPair.from_json(pair)}
      
        return self.new(cs, ts, ps)
      end
    
    
      def to_json()

        cs = @cameras.collect{ |camera| camera.to_json() }
      
        ts = @targets.collect{ |target| target.to_json() }
        
        ps = @pairs.collect{|pair| pair.to_json() }

        json = {"cameras" => cs, "targets" => ts, "pairs" => ps }
        return json
      end
      
      def get_pairs()
        ps = @pairs.collect{ |p|
          [get_camera(p.camera_id), get_target(p.target_id)]
        }
        return ps
      end
      
      def get_camera(id)
        @cameras.each{|camera| 
          if camera.id == id
            return camera
          end
        }
        return nil
      end
      
      def get_target(id)
        @targets.each{ |target|
          if target.id == id
            return target
          end
        }
        return nil
      end
      
    end
    
  end
end