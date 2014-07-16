

require "/Users/Jing/OneDrive/3DMotionDB/tools/base_json/src/basic_json.rb"

module NPLAB
    JSON_IO="json_io"
    #
    # load the setting from a file
    #
    def self.load_from_json(model, filename)
      
      raise "No implemention"
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
          up        = get_up(inst)
          
          camera  =  {"id" => id, "position"=> to_m(position), "up"=>to_m(up)}
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
          up        = get_target_up(inst)
          target = {"id" => id, "position" => to_m(position), "up"=> to_m(up)}
          targets << target
        }
      end
      
      # pair information
      pairs = get_pairs_idx(model)
      
        
      hash = {"cameras"=>cameras, "targets"=>targets, "pairs"=>pairs}

    end

end