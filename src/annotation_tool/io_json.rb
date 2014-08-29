require "#{File.dirname(__FILE__)}/libs.rb"

module NPLAB
  JSON_IO="json_io"
  #
  # load the setting from a file
  #
  def self.load_setting_from_json(model, filename)
    json = BasicJson.load(filename) 
    json_to_cameras(model, json["cameras"])
    json_to_targets(model, json["targets"])
    json_to_pairs(model,   json["pairs"])
  end
  
  def self.json_to_cameras(model, json)
    camera_definition = self.get_definition(model, CN_CAMERA, FN_CAMERA)
    json.each{ |j|
      id     = j["id"]
      tr     = Utils.hash_to_transf(j["position"])
      transf = Utils.to_instance_transformation(tr)
      new_instance(model, camera_definition, transf, LN_CAMERAS, id)
    }
  end
  
  def self.json_to_targets(model, json)
    target_definition = self.get_definition(model, CN_TARGET, FN_TARGET)
    json.each{ |j|
      id     = j["id"]
      transf = Utils.hash_to_transf(j["position"])
      new_instance(model, target_definition, transf, LN_TARGETS, id)
    }
  end
  
  def self.json_to_pairs(model, json)
    set_pairs_in_json(model, json)
  end
    
    
    
  # 
  # save the setting to a file
  #
  def self.save_setting_to_json(model, filename)
    cameras = camera_annotation_to_json(model)
    targets = target_annotation_to_json(model)
    pairs   = pair_annotation_to_json(model)
    json    = {"cameras"=>cameras, "targets"=>targets, "pairs"=>pairs}
  
    BasicJson.save(filename, json) 
    return json    
  end
  
  private

  
  def self.camera_annotation_to_json(model)
    cameras = []
    
    definition = model.definitions[CN_CAMERA]
    if definition
      instances = definition.instances
      instances.each{ |inst|
        
        id        = inst.get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s)
        transf    = Utils.to_camera_centered_transformation(inst.transformation)
        camera    =  {"id" => id, "position"=> Utils.transf_to_hash(transf)}
        cameras   << camera
      }
    end
    
    return cameras
  end
 
  def self.target_annotation_to_json(model)
    
    targets = []
    definition = model.definitions[CN_TARGET]
    if definition
      instances = definition.instances
      instances.each{ |inst|
        id        = inst.get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s) 
        transf    = inst.transformation
        target = {"id" => id, "position"=> Utils.transf_to_hash(transf)}    
        targets << target
      }
    end
    return targets
  end

  def self.pair_annotation_to_json(model)
    pairs = get_pairs_in_json(model)
    return pairs
  end

end