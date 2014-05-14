require "#{File.dirname(__FILE__)}/annotation.rb"
require "#{File.dirname(__FILE__)}/ui_small_tools.rb"
# load('/Users/Jing/Library/Application Support/SketchUp 2013/SketchUp/Plugins/annotation/ui_target_tool.rb')
########################

########################
# this tool will assume there is less than one camera in the scene. If not so,
# it will just working on the first camera
module NPLAB_UI
	class CTargetTool
	
#		def self.is_valid()
#			model = Sketchup.active_model
#			definition = model.definitions[NPLAB::CN_CAMERA]
#			if model.selected
#			if definition != nil && definition.instances.size <= 1
#				return MF_ENABLED
#			end
#			return MF_GRAYED
#		end
		
		def activate()
			@target_def = NPLAB.get_definition(Sketchup.active_model, NPLAB::CN_TARGET, NPLAB::FN_TARGET)
			Sketchup.set_status_text "Double click to add a new focal point. (" + @target_def.instances.length.to_s + ")"
			Sketchup.active_model.active_view.refresh
		end
		
		def onLButtonDoubleClick(flags, x, y, view)
			Sketchup.active_model.start_operation("add target")
			new_target = add_target(x, y, view)
			Sketchup.set_status_text "Double click to add a new focal point (" + @target_def.instances.length.to_s + ")"	
			Sketchup.active_model.commit_operation
			view.refresh
		end
	
		def add_target(x, y, view)
			inputpoint = view.inputpoint x,y
			# target must on a face or an edge
			# && inputpoint.edge == nil && inputpoint.vertex == nil
			if inputpoint.face == nil 
				return nil
			end
		
			origin = inputpoint.position
			if inputpoint.vertex 
				origin = inputpoint.vertex.position
				input_transformation = inputpoint.transformation
				origin.transform!(input_transformation)
			end
		
			normal = Geom::Vector3d.new [0, 0, 1]
			if inputpoint.face
				 normal = inputpoint.face.normal
				 input_transformation = inputpoint.transformation
				 normal.transform!(input_transformation)
			end
		
			transformation = Geom::Transformation.new(origin, normal)
			new_target = NPLAB.new_instance(Sketchup.active_model, @target_def, transformation, NPLAB::LN_TARGETS)
			return new_target
		end
	
		def onCancel(reason, view)
			if reason == 1
				Sketchup.active_model.select_tool(nil)
			end
		end
	end
end
