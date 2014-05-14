require "#{File.dirname(__FILE__)}/annotation.rb"
# load("/Users/Jing/Library/Application Support/SketchUp 2013/SketchUp/Plugins/annotation/ui_small_tools.rb")
module NPLAB_UI
	
	def self.get_transf(x, y, view)
		inputpoint = view.inputpoint x,y
		t = inputpoint.transformation
		origin = inputpoint.position
		if inputpoint.vertex 
			origin = inputpoint.vertex.position
			origin.transform! t
		end
		
		normal = Geom::Vector3d.new [0, 0, 1]
		if inputpoint.face != nil 
			 normal = inputpoint.face.normal
			 normal.transform! t
		end
				
		transformation = Geom::Transformation.new(origin, normal)	
		return transformation
	end
	
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
	
	def self.ui_flip_camera_v()
		model = Sketchup.active_model
		selection = model.selection
		selection.each { |instance| 		
			if instance.typename=="ComponentInstance" && instance.name== NPLAB::CN_CAMERA
			end
		}
	end
	
	def self.flip_instance(instance)
		orgt = instance.transformation
		origin = orgt.origin
		zaxis = [0, 0, 0] - orgt.zaxis
		newt = Geom::Transformation.new(origin, zaxis) 
		instance.transformation= newt	
	end
end

