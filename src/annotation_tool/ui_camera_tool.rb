require "#{File.dirname(__FILE__)}/annotation.rb"
require "#{File.dirname(__FILE__)}/ui_small_tools.rb"
# load("/Users/Jing/OneDrive/3DMotionDB/src/annotation_tool/ui_camera_tool.rb")
module NPLAB
	
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
      
      model.start_operation("Enter camera editing mode")
			@camera_def = NPLAB.get_definition(Sketchup.active_model, NPLAB::CN_CAMERA, NPLAB::FN_CAMERA)
			@active_camera = @camera_def.instances.size == 0 ? nil : @camera_def.instances[0]	
			
			clayer = model.layers[NPLAB::LN_CAMERAS]
			if clayer == nil
				clayer	= model.layers.add(NPLAB::LN_CAMERAS)
			end
			clayer.visible=true
      model.commit_operation
		end
	
		def onLButtonUp(flags, x, y, view)
			status = Sketchup.active_model.start_operation('Set Camera', true)
      
      # not pick the camera itself  
      ph = view.pick_helper
      ph.do_pick(x, y)   
      all_picked = ph.all_picked   
      if all_picked      
        all_picked.each{ |entity|
          # puts "typename: #{entity.typename}"
          if entity.typename == "ComponentInstance" && entity.definition.name == NPLAB::CN_CAMERA
            # UI.messagebox("You cannot put the camera on itself")
            return
          end    
        }
      end
   
			transformation = NPLAB.get_transf(x, y, view)
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