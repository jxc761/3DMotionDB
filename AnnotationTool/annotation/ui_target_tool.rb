require "#{File.dirname(__FILE__)}/annotation.rb"
require "#{File.dirname(__FILE__)}/ui_small_tools.rb"
# load('/Users/Jing/Library/Application Support/SketchUp 2013/SketchUp/Plugins/annotation/ui_target_tool.rb')
########################

########################
# this tool will assume there is less than one camera in the scene. If not so,
# it will just working on the first camera
module NPLAB_UI
	class CTargetTool
		def is_ok()
			model = Sketchup.active_model
			definition = model.definitions[NPLAB::CN_CAMERA] 
			if definition != nil && definition.instances.size == 1
				return true
			end
			return false
		end
		
		def activate()
			@is_active = true
			if !is_ok()
				@is_active = false
				UI.messagebox("The number of camera must be 1.")
				Sketchup.active_model.select_tool(nil)
				return
			end
			
			store_status()
			@target_def = NPLAB.get_definition(Sketchup.active_model, NPLAB::CN_TARGET, NPLAB::FN_TARGET)
			
			# initialize the status 
			@clayer.visible = false	
            camera_def     = NPLAB.get_definition(Sketchup.active_model, NPLAB::CN_CAMERA, NPLAB::FN_CAMERA)
			@active_camera = camera_def.instances[0]
			@cur_target    = Sketchup.active_model.active_view.camera.target
			@cur_x = nil
			@cur_y = nil
			@cur_fov = @org_fov
			Sketchup.set_status_text "There are(is) " + @target_def.instances.length.to_s + "focal point(s) in the scene."
			Sketchup.active_model.active_view.refresh
		
		end
	
		def draw(view)
			# for debug
			if @active_camera == nil
				UI::messagebox("error")
				return
			end	
			# end for debug 
			
			up = NPLAB.get_up(@active_camera)
			eye = NPLAB.get_eye_position(@active_camera)
			view.camera.set(eye, @cur_target, up)	
			view.camera.fov=@cur_fov
			
		end
	
		def onLButtonUp(flags, x, y, view)
			Sketchup.active_model.start_operation("add target")
			new_target = add_target(x, y, view)
			if new_target != nil
				@cur_target = NPLAB.get_target_position(new_target)	
			end
			Sketchup.set_status_text "There are(is) " + @target_def.instances.length.to_s + "focal point(s) in the scene."
			Sketchup.active_model.commit_operation
			view.refresh
		end
	
		def onMouseMove(flags, x, y, view)
			
			if @cur_x == nil || @cur_y == nil
				@cur_x = x
				@cur_y = y
				return
			end
			
			if (flags & VK_COMMAND) == 0
				@cur_x = x
				@cur_y = y
				return
			end
			
			dx = x - @cur_x
			dy = y - @cur_y
		
			delta 	= 0.005
			thresh	= 5.0
		
		
			delta_h = (dx > 0 ? delta : -delta) * (dx.abs > thresh ? thresh : dx.abs)
			delta_z = (dy > 0 ? delta : -delta) * (dy.abs > thresh ? thresh : dy.abs)
		
			if (flags & VK_ALT != 0)
				delta_z = 0
			elsif (flags &  VK_SHIFT!= 0)
				delta_h = 0
			end

			rotate(delta_h, delta_z)
		
			@cur_x = x 
			@cur_y = y 
			view.refresh
		end
	
		def onKeyDown(key, repeat, flags, view)
			delata_fov	= 0
			delta_h = 0
			delta_z = 0
			
			if (flags & VK_COMMAND != 0)
				if key == VK_UP
					delata_fov = 5
				elsif key == VK_DOWN
					delata_fov = -5
				end
				#puts alpha 
				zoom(delata_fov)
			else
				case key
				when VK_LEFT
					delta_h = 0.025
				when VK_RIGHT
					delta_h = -0.025
				when VK_UP
					delta_z = 0.025
				when VK_DOWN
					delta_z = -0.025
				else
				end
				rotate(delta_h, delta_z)
			end
		
			view.refresh
		end
		
		def deactivate(view)
			if @is_active
				restore_status()
				view.refresh
			end
		end
		
		#--------------------------------------------------------------------------------
		# store the status
		#-------------------------------------------------------------------------------
		def store_status()
			# store the camera information
			model =  Sketchup.active_model
			camera = Sketchup.active_model.active_view.camera
			@org_eye 	= Geom::Point3d.new(camera.eye)
			@org_up  	= Geom::Vector3d.new(camera.up)
			@org_target = Geom::Point3d.new(camera.target)
			@org_fov = camera.fov
		
			# store the layer visibility information
			@clayer = model.layers[NPLAB::LN_CAMERAS]
			if @clayer == nil
				@clayer	= model.layers.add(NPLAB::LN_CAMERAS)
			end
			@is_camera_layer_visible = @clayer.visible?
		end
	
		#--------------------------------------------------------------------------------
		# recover the status
		#-------------------------------------------------------------------------------
		def restore_status()
		
			Sketchup.active_model.active_view.camera.set(@org_eye, @org_target, @org_up)
			Sketchup.active_model.active_view.camera.fov= @org_fov
			@clayer.visible = @is_camera_layer_visible
		end
		
		#--------------------------------------------------------------------------------
		# add a target at the 3d position corresponding to (view, x, y)
		#--------------------------------------------------------------------------------
		def add_target(x, y, view)
			inputpoint = view.inputpoint x,y
			
			# the target must be on a face 
			if inputpoint.face == nil # && inputpoint.edge == nil && inputpoint.vertex == nil
				return nil
			end
			
			transformation = NPLAB_UI.get_transf(x, y, view)
			new_target = NPLAB.new_instance(Sketchup.active_model, @target_def, transformation, NPLAB::LN_TARGETS)
			return new_target
		end
	
	
		def rotate(delta_h, delta_z)
			eye = NPLAB.get_eye_position(@active_camera)
			up 	= NPLAB.get_up(@active_camera)
			w 	= eye - @cur_target
			u 	= up * w 
			u.normalize!
			t1	= Geom::Transformation.rotation eye, u, delta_z 
			t2 	= Geom::Transformation.rotation eye, up, delta_h
			@cur_target.transform!(t1)
			@cur_target.transform!(t2)
		end
	
		# if alpha > 0 zoom in
		# if alpha < 0 zoom out
		def zoom(alpha)
			@cur_fov= @cur_fov + alpha
			@cur_fov = @cur_fov > 120 ? 120 : @cur_fov
			@cur_fov = @cur_fov < 15 ? 15 : @cur_fov
		end

	end
end
