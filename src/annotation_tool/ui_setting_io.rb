
require "#{File.dirname(__FILE__)}/annotation.rb"

module NPLAB
  
	#----------------------------------------------------------------
	#
	#----------------------------------------------------------------	
  def self.ui_load_setting()
    
    # clear current setting
    result = UI.messagebox("Loading setting will erase current setting. Do you want to continue?",  MB_YESNO)
    if result == IDNO
       Sketchup.active_model.select_tool(nil)
       return
    end
    reset_all_setting()
    
    model     = Sketchup.active_model
		directory = File.dirname(model.path)
    
    filename = UI.openpanel("Load Setting", directory, "TEXT|*.txt|JSON|*.json||")
		if filename == nil
      Sketchup.active_model.select_tool(nil)
			return 
		end
    
    case File.extname(filename).downcase
    when ".txt"
      load_setting_from_text(model, filename)
    when ".json"
      load_setting_from_json(model, filename)
    else
      UI.messagebox("Unknow file type")
      return
    end
    Sketchup.active_model.select_tool(nil)
    Sketchup.set_status_text "Successfully load file: #{filename}"   
  end
  
	#----------------------------------------------------------------
	#
	#----------------------------------------------------------------	
	def self.ui_save_setting()

    # pre-test for stupid user.
    if Sketchup.active_model.path.empty?
      UI.messagebox("Please save the scene file first!")
      return
    end
    
    if self.get_camera_number() == 0
      UI.messagebox("Nothing to save!")
      return
    end
    
    if self.get_target_number() == 0
      UI.messagebox("Please note that there is no target in the scene")
    end
    
    # where to save
    model = Sketchup.active_model
    model_dir   = File.dirname(model.path)
    model_name  = File.basename(model.path, '.skp')
    

    dn_output  = ( NPLAB.auto_path? ) ? model_dir : NPLAB.path_to_output()
    #UI.messagebox("NPLAB.auto_path?:#{NPLAB.auto_path?}");
    #UI.messagebox("model_dir: #{model_dir}")
  
    filename =  File.join(dn_output, "#{model_name}.cts.json")
    #UI.messagebox("dn_output: #{dn_output}")
    #UI.messagebox("filename: #{filename}")
    unless NPLAB.single_cts?
      index = 1
      while File.file?(filename)
        #UI.messagebox("#{filename}: #{File.file?(filename)}")
        filename =  File.join(dn_output, "#{model_name}_#{index}.cts.json")
        index += 1
      end
    end

    #save out
    model.start_operation "Save Annotation"

    if NPLAB.relabel?
      NPLAB.relabel_annotation()
    end
    NPLAB.full_pairs(model)
		
    save_setting_to_json(model, filename)
    
    model.commit_operation 
    
    Sketchup.active_model.select_tool(nil)
    Sketchup.set_status_text "The setting have been saved to: #{filename}"
    # Sketchup.active_model.select_tool(nil)
	end


	#----------------------------------------------------------------
	#
	#----------------------------------------------------------------
  def self.ui_save_setting_as()
    if self.get_camera_number() == 0 || self.get_target_number() == 0
      UI.messagebox("Nothing to save!")
      return
    end
    
    if self.get_target_number() == 0
      UI.messagebox("Please note that there is no target in the scene")
    end
    
		model = Sketchup.active_model
		directory = File.dirname(model.path)
		basename = File.basename(model.path, ".skp" ) 
		filename = UI.savepanel("Save Setting", directory,  basename + ".txt")
		if filename == nil
			return 
		end
    
    if File.extname(filename).empty?
      filename = filename + ".txt"
    end
    
    
    NPLAB.full_pairs(model)
    case File.extname(filename).downcase
    when ".txt"
      save_setting_to_text(model, filename)
    when ".json"
      save_setting_to_json(model, filename)
    else
      UI.messagebox("Unknow file type")
      return
    end
    
		Sketchup.set_status_text "The setting have been saved to: #{filename}"    
  end
  
  def self.gen_file_name(model, ext=".cts.json")
  		prefix = model.path.sub(/\.skp$/,"")
  		
  		return filename
  	end

	def self.reset_all_setting()
		model = Sketchup.active_model

		# clear model
		NPLAB.set_pairs_in_text(model, "")
		NPLAB.remove_all_instances(model, NPLAB::CN_CAMERA)
		NPLAB.remove_all_instances(model, NPLAB::CN_TARGET)


		# load in component definitions
		NPLAB.get_definition(model, NPLAB::CN_CAMERA, NPLAB::FN_CAMERA)
		NPLAB.get_definition(model, NPLAB::CN_TARGET, NPLAB::FN_TARGET)

		# add two layers into 
		if  model.layers[NPLAB::LN_CAMERAS] == nil
			model.layers.add(NPLAB::LN_CAMERAS)
		end

		if model.layers[NPLAB::LN_TARGETS] == nil
			model.layers.add(NPLAB::LN_TARGETS)
		end

		# set both layer
		model.layers[NPLAB::LN_CAMERAS].visible= true
		model.layers[NPLAB::LN_TARGETS].visible= true
	
	end



end