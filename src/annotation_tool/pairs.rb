require "sketchup"

module NPLAB
  # 
  # Information of pairs is store as an attribute of model.
  # The dictionary name is DICT_NAME and the attribute name is  "paris"
  # 
  # The attribute is formated as
  #    
  # <camera_id> : <target_id> 
  # <camera_id> : <target_id>
  #
  
  def self.get_pairs_in_text(model)
    text = model.get_attribute(DICT_NAME, AN_PAIRS, "")
    return text
  end
  
  def self.set_pairs_in_text(model, t)  
    model.set_attribute(DICT_NAME, AN_PAIRS, t)
  end
  
  def self.get_pairs_in_array(model)
    txt = get_pairs_in_text(model)
    
    substrs=txt.split("\r\n")
    array = []
    substrs.each{|substr|
	    substr.strip!
      next if substr.empty?
      ids = substr.split(":")
      array << [ids[0], ids[1]]
    }
    return array
  end
  
  def self.set_pairs_in_array(model, array)
    txt = ""
    array.each{|pair|
      txt << pair[0] << ":" << pair[1] << "\r\n"
    }
    return set_pairs_in_text(model, txt)
  end
  
  
  def self.get_pairs_in_json(model)
    
    array = get_pairs_in_array(model)
    json = array.collect{|pair| {"camera_id" => pair[0], "target_id" => pair[1]} }
    return json
  end
  
  def self.set_pairs_in_json(model, json)
    array = json.collect{|hash| [ hash["camera_id"], hash["target_id"] ]}
    return set_pairs_in_array(model, array)
  end
  
  
  def self.get_pairs_in_insts(model)
    array = get_pairs_in_array(model)
    pairs = array.collect{ |ids|
      [find_instance(model, CN_CAMERA, ids[0]), find_instance(model, CN_TARGET, ids[1])]
    }
    return pairs
  end
  
  def self.set_pairs_in_insts(model, pairs) 
    array = pairs.collect{|pair|
      [
        pair[0].get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s),
        pair[1].get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s)
      ]
    }
    return set_pairs_in_array(model, array)
  end
  
  
  def self.full_pairs(model)
		
		model       = Sketchup.active_model
		camera_def  = NPLAB.get_definition(model, NPLAB::CN_CAMERA, NPLAB::FN_CAMERA)
		cameras     = camera_def.instances
		target_def  = NPLAB.get_definition(model, NPLAB::CN_TARGET, NPLAB::FN_TARGET)
		targets     = target_def.instances
	
		pairs = []
		cameras.each{|camera|
			targets.each{|target|
				pairs << [camera, target]
			}
		}
    set_pairs_in_insts(model, pairs)
  end
  

  def self.clear_pairs(model)
    pairs = get_pairs_in_inst(model)
    new_pairs = []
    pairs.each{ |pair|
      if pair[0]!=nil && pair[1] != nil
        new_pairs << pair
      end
    }
    set_pairs_in_insts(model, new_pairs)
  end
  
  
end