require "sketchup"

module NPLAB
  

  # pairs is store as an attribute
  # the dictionary name is DICT_NAME
  # the attribute name is  "paris"
  #
  #
  
   def self.str_to_pairs(model, s)
    substrs=s.split("\r\n")

    substrs.each{|substr|
      next if substr== ""
      ids = substr.split(":")
      camera = find_instance(model, ids[0])
      target = find_instance(model, ids[1])
      pairs << [camera, target]
    }
    
    return pairs
  end

   def self.pairs_to_str(pairs)
    if pairs==nil
      return ""
    end
    s  = ""
    pairs.each{|pair|
      camera_id = pair[0].get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s)
      target_id = pair[1].get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s)
      s << camera_id << ":" << target_id << "\r\n"
    }
    return s 
  end
  
  
  # 
  def self.get_pairs(model)
    attr = model.get_attribute(DICT_NAME, AN_PAIRS, "")
    return str_to_pairs(model, s)
  end
  
  def self.set_pairs(model, pairs)
    attr = pairs_to_str(pairs)
    model.set_attribute(DICT_NAME, AN_PAIRS, attr)
  end

  def self.clear_pairs(model)
    pairs = get_pairs(model)
    new_pairs = []
    pairs.each{ |pair|
      if pair[0]!=nil && pair[1] != nil
        new_pairs << pair
      end
    }
    set_pairs(model, new_pairs)
  end

  
end