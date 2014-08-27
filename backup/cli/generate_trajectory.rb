module NPLAB
  module CLI
    
    
    def self.generate_trajectory(fn_skp, fn_setting, fn_conf, fn_buf, fn_output)
      model = Sketchup.open(fn_skp) 
      
      # load in the camera setting
      # cameras, 
      setting = BasicJson.load_from_json(fn_setting)
      cameras = setting["cameras"].each{|a| a["id"] => a}
      targets = setting["targets"].collect{|a| a["id"] => a}
      pairs   = setting["pairs"]
      
      pairs.each{ |pair|
        camera = cameras[pairs["camera_id"]]
        target = targets[pairs["target_id"]]
        camera.location
      }
      
       
    end
    
    private
    
    def self.build_map(array)
      hash = array.collect{|a|
        a["id"] => a
      }
    end
    
  end
end