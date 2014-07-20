

require "#{File.dirname(__FILE__)}/libs.rb"


module NPLAB
    JSON_IO="json_io"
    #
    # load the setting from a file
    #
    def self.load_from_json(model, filename)
      hash 
      raise "No implemention"
    end
    
    
    def self.load_json(filename)
      hash = BasicJson.load_from_json(filename) 
      return hash
    end
    # 
    # save the setting to a file
    #
    def self.save_to_json(model, filename)
      hash = annotation_to_hash(model)
      BasicJson.write_to_json(filename, hash)     
    end
    
    private
    def self.to_m(pt)
      a = [pt[0].to_m, pt[1].to_m, pt[2].to_m]
    end

    def self.annotation_to_hash(model)
      
      # camera information
      cameras = []
      
      definition = model.definitions[CN_CAMERA]
      if definition
        instances = definition.instances
        instances.each{ |inst|
          
          id        = inst.get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s)
          position  = get_eye_position(inst)
          transf    = inst.transformation
          origin    = transf.origin
          xaxis     = transf.xaxis
          yaxis     = transf.yaxis
          zaxis     = transf.zaxis
          
          camera  =  {"id" => id, "position"=> to_m(position), "origin" => to_m(origin),
            "xaxis" => to_m(xaxis), "yaxis" => to_m(yaxis), "zaxis"=>to_m(zaxis)}
          cameras << camera
        }
      end
      
      # target information
      targets = []
      definition = model.definitions[CN_TARGET]
      if definition
        instances = definition.instances
        instances.each{ |inst|
          id        = inst.get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s)
          position  = get_target_position(inst)
          
          transf    = inst.transformation
          origin    = transf.origin
          xaxis     = transf.xaxis
          yaxis     = transf.yaxis
          zaxis     = transf.zaxis
          
          target = {"id" => id, "position" => to_m(position), "origin" => to_m(origin),
            "xaxis" => to_m(xaxis), "yaxis" => to_m(yaxis), "zaxis"=>to_m(zaxis)}
            
          targets << target
        }
      end
      
      # pair information
      pairs = get_pairs_idx(model)
      
      hash = {"cameras"=>cameras, "targets"=>targets, "pairs"=>pairs}

    end

end