require "#{File.dirname(__FILE__)}/annotation.rb"
require "#{File.dirname(__FILE__)}/ui_small_tools.rb"
# load("/Users/Jing/Library/Application Support/SketchUp 2013/SketchUp/Plugins/annotation/ui_camera_tool.rb")

module NPLAB_UI
	
	########################
	# this tool will assume there is less than one camera in the scene. If not so,
	# it will just working on the first camera
	class CCameraTool
		
#		def self.is_valid()
#			model = Sketchup.active_model
#			definition = model.definitions[NPLAB::CN_CAMERA]
#			if definition != nil && definition.instances.size > 1
#				return MF_GRAYED
#			end
#			return MF_ENABLED
#		end
	
		def activate()
			model = Sketchup.active_model
			@camera_def = NPLAB.get_definition(Sketchup.active_model, NPLAB::CN_CAMERA, NPLAB::FN_CAMERA)
			@active_camera = @camera_def.instances.size == 0 ? nil : @camera_def.instances[0]	
			
			clayer = model.layers[NPLAB::LN_CAMERAS]
			if clayer == nil
				clayer	= model.layers.add(NPLAB::LN_CAMERAS)
			end
			clayer.visible=true
		end
	
		def onLButtonUp(flags, x, y, view)
			status = Sketchup.active_model.start_operation('set_camera', true)
		
			transformation = NPLAB_UI.get_transf(x, y, view)
			if @active_camera == nil
				@active_camera  = NPLAB.new_instance(Sketchup.active_model, @camera_def, transformation, NPLAB::LN_CAMERAS)
			else
				@active_camera.transformation=transformation
			end
		
			Sketchup.active_model.commit_operation
			view.invalidate
		end

		def onCancel(reason, view)
			Sketchup.active_model.select_tool(nil)
		end
	end
	
end