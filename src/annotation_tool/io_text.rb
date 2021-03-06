module NPLAB
  
    TN_TARGETS = "targets" # TN: tagname
    TN_CAMERAS = "cameras"  
    TN_PAIRS = "pairs"

   
    #----------------------------------------------------------------
    # load 
    #----------------------------------------------------------------
    def self.load_setting_from_text(model, filename)
      file = File.open(filename, "r")
      lines = file.readlines()
      file.close()

      # load camera
      camera_part = load_part(lines, TN_CAMERAS)
      camera_definition = self.get_definition(model, CN_CAMERA, FN_CAMERA)
      camera_part.each{ |line|
        instance_from_s(model, camera_definition, LN_CAMERAS, line)
      }
	  
      #load targets
      target_part = load_part(lines, TN_TARGETS)
      target_definition = self.get_definition(model, CN_TARGET, FN_TARGET)
      target_part.each{ |line|
        instance_from_s(model, target_definition, LN_TARGETS, line)
      }
      target_definition = self.get_definition(model, CN_TARGET, FN_TARGET)
	  
      #load pairs
      pair_part = load_part(lines, TN_PAIRS)
      set_pairs_in_text(model, pair_part.join("\r\n"))
      
	    #pairs = ""
      #
	    #pair_part.each{ |line|
		  #  pairs << line
	    #}
      #model.set_attribute(DICT_NAME, AN_PAIRS, pairs)
    end

    def self.instance_from_s(model, definition, layer_name, s)
      ta = []
      substrs = s.split(%r{[\s:,\|]+})
      substrs[1..-1].each{|v| ta << v.to_f }   
      hash = {:id=> substrs[0], :transformation => ta}
      id =  substrs[0]
      transformation = Geom::Transformation.new(ta)
      new_instance(model, definition, transformation, layer_name, id)
    end
    
   
    # load all lines between
    def self.load_part(lines, tagName)
      part = []
      status = 0

      lines.each{ |line|
        if line.strip == ("=begin_" + tagName)
        	status = 1 #beginning
        	next
        elsif line.strip == ("=end_" + tagName)
        	# status = 0 #end
        	# next
        	break
        end

        # read in all cameras
        if status==1 && line =~ %r{[\s]*}
        	part << line
        end
      }
      return part
    end
    
    
    
    #----------------------------------------------------------------
    # save
    #----------------------------------------------------------------
    def self.instance_to_s(inst)
      id = inst.get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s)
      ta = inst.transformation.to_a
      s  = id
      ta.each{|a|
        s << ":" << a.to_s 
      }
      return s
    end
	
    def self.save_setting_to_text(model, filename)
      # cameras part 
      camera_definition = model.definitions[CN_CAMERA]
      cameras = ""
      if camera_definition != nil
        instances = camera_definition.instances
        instances.each{ |inst|
			s= instance_to_s(inst)
			cameras <<  s << "\r\n"
        }
      end
      
      
      # targets part
      target_definition = model.definitions[CN_TARGET]
      targets = ""
      if target_definition != nil
        instances = target_definition.instances
        instances.each{ |inst|
          targets << instance_to_s(inst) << "\r\n"
        }
      end
      
      # pairs part
      # get_attribute(DICT_NAME, AN_PAIRS, "")
      pairs = get_pairs_in_text(model)
 
      cameras_part = "=begin_#{TN_CAMERAS}\r\n#{cameras}=end_#{TN_CAMERAS}\r\n"
      targets_part = "=begin_#{TN_TARGETS}\r\n#{targets}=end_#{TN_TARGETS}\r\n"
      pairs_part = "=begin_#{TN_PAIRS}\r\n#{pairs}=end_#{TN_PAIRS}\r\n"
      
      txt = "#{cameras_part}#{targets_part}#{pairs_part}"
      
      file=File.open(filename, "w")
      file.write(txt)
      file.close()
      
    end
    

end