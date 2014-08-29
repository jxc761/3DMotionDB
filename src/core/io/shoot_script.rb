module NPLAB
  module CoreIO
    
    class CShootScript < NPLAB::BasicJson::CJsonObject
      # target : CTarget
      # camera : CCamera
      # camera_tr: Array<Transformation>
      attr_accessor  :target, :camera, :camera_tr
      
      def initialize(c, t, tr)
        @target = t
        @camera = c
        @camera_tr = tr
      end  
      
      def to_json()
        json = {  
          "target" => @target.to_json(),
          "camera" => @camera.to_json(),
          "camera_tarjectory" => @camera_tr.to_json()}
        return json
      end
     
      def self.from_json(json)
        t   = CTarget.from_json(json["target"])
        c   = CCamera.from_json(json["camera"])
        tr  = CTrajectory.from_json(json["camera_trajectory"])
        return self.new(c, t, tr)
      end
     
    end
 
  end
end