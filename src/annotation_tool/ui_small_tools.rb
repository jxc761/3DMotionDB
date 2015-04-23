require "#{File.dirname(__FILE__)}/annotation.rb"
# load("/Users/Jing/Library/Application Support/SketchUp 2013/SketchUp/Plugins/annotation/ui_small_tools.rb")
module NPLAB

  # ------------------------------------------------
  # Clear annoation
  # ------------------------------------------------
  def self.ui_clear_annoation()
    model = Sketchup.active_model

    model.start_operation "Clear Annotation"

    # clear all related instances
		NPLAB.remove_all_instances(model, NPLAB::CN_CAMERA)
		NPLAB.remove_all_instances(model, NPLAB::CN_TARGET)
    
    # clear pairs setting
    model.attribute_dictionaries.delete(NPLAB::DICT_NAME)
    
    # remove all related definition
    model.definitions.purge_unused()
    
    # remove all related layers
    model.layers.purge_unused()
    
    Sketchup.active_model.active_view.refresh
    Sketchup.set_status_text "Clean!"
    
    model.commit_operation 
    
    Sketchup.active_model.select_tool(nil)
  end
  
  
  # ------------------------------------------------
  # show & hide all setting
  # ------------------------------------------------
  def self.ui_show_setting()
    Sketchup.active_model.start_operation "Show camera target setting"
    
		layer = Sketchup.active_model.layers[NPLAB::LN_CAMERAS]
		if layer
      layer.visible=true
    end
    
    layer = Sketchup.active_model.layers[NPLAB::LN_TARGETS]
		if layer
      layer.visible=true
    end
	
    Sketchup.active_model.commit_operation
    Sketchup.active_model.select_tool(nil)
  end
  
  def self.ui_hide_setting()
    Sketchup.active_model.start_operation "Hide camera target setting"
    
		layer = Sketchup.active_model.layers[NPLAB::LN_CAMERAS]
		if layer
      layer.visible=false
    end
    
    layer = Sketchup.active_model.layers[NPLAB::LN_TARGETS]
		if layer
      layer.visible=false
    end
	
    Sketchup.active_model.commit_operation
    Sketchup.active_model.select_tool(nil)
  end
  
  # ------------------------------------------------
  # show setting information
  # ------------------------------------------------
  
  def self.ui_show_setting_info()
    nc = NPLAB.get_camera_number()
    nt = NPLAB.get_target_number()
    msg = "#Cameras: #{nc}\r\n#Targets: #{nt}\r\n"
    UI.messagebox(msg)
    #Sketchup.active_model.select_tool(nil)
  end
  
  
  
  # ------------------------------------------------
  # flip camera
  # ------------------------------------------------
	def self.ui_flip_camera_validation()
		
		model = Sketchup.active_model
		selection = model.selection
		if model.selection.length != 1
			return MF_GRAYED
		end
		
		if model.selection[0].typename != "ComponentInstance" || model.selection[0].definition.name != NPLAB::CN_CAMERA
			return MF_GRAYED
		end
		
		return MF_ENABLED
	end
	
	def self.ui_flip_camera()
		model = Sketchup.active_model
    
    model.start_operation "Flip camera"
    
		instance= model.selection[0]	
		orgt = instance.transformation
		newt = Geom::Transformation.new(orgt.origin, Geom::Vector3d.new([0,0,0]) - orgt.zaxis)
		instance.transformation= newt
    
    model.commit_operation
    
	end
	
	def self.flip_instance(instance)
		orgt = instance.transformation
		origin = orgt.origin
		zaxis = [0, 0, 0] - orgt.zaxis
		newt = Geom::Transformation.new(origin, zaxis) 
		instance.transformation= newt	
	end
	
end



=begin
  
	def self.reset_tool_status()
		model = Sketchup.active_model
	
		# clear model
		NPLAB.set_pairs(model, [])
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
	
	def self.ui_reset_tool_status()
	 	reset_tool_status()
	 	#Sketchup.active_model.select_tool(nil)
		Sketchup.set_status_text "Setting restored"
		Sketchup.active_model.active_view.refresh
	end
	
=end