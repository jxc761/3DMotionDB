require "#{File.dirname(__FILE__)}/annotation.rb"
require "#{File.dirname(__FILE__)}/ui_small_tools.rb"

########################

########################
module NPLAB

  class CTargetTool


  	def activate()
  		puts "activate"
  		Sketchup.active_model.start_operation "pick targets"

  		@cur_x = nil
  		@cur_y = nil

  		# save current setting
  		camera = Sketchup.active_model.definitions[NPLAB::CN_CAMERA].instances[0]
			view 		= Sketchup.active_model.active_view
			vc = view.camera
			
  		@old_camera=Sketchup::Camera.new(vc.eye, vc.target, vc.up, vc.perspective?, vc.fov)
  		@org_target_numb=NPLAB.get_target_number()
  		@b_visible=Sketchup.active_model.layers[NPLAB::LN_CAMERAS].visible?
  	

			# change to camera view
			camera.layer.visible=false
  		new_view_camera = NPLAB.change_to_camera_view(view.camera , camera)
  		view.camera=new_view_camera, 1
  		view.refresh()

			Sketchup.active_model.commit_operation
  	end

  	def add_target(x, y, view)
  		inputpoint = view.inputpoint x,y
			 # the target must be on a face 

			if inputpoint.face == nil # && inputpoint.edge == nil && inputpoint.vertex == nil
			 	return nil
			end

			transformation = NPLAB.get_transf(x, y, view)
			definition     = NPLAB.get_definition(Sketchup.active_model, NPLAB::CN_TARGET, NPLAB::FN_TARGET)
			new_target 		= NPLAB.new_instance(Sketchup.active_model, definition, transformation, NPLAB::LN_TARGETS)
  	end


  	def onLButtonDoubleClick(flags, x, y, view)
  		Sketchup.active_model.start_operation("add target")
  		@cur_x = x
			@cur_y = y
			 	
			add_target(x, y, view)
			Sketchup.set_status_text "#focal points: #{NPLAB.get_target_number()}"
			Sketchup.active_model.commit_operation
  		view.refresh
  	end


		def onMouseMove(flags, x, y, view)
				
			
			if @cur_x == nil || @cur_y == nil
				@cur_x = x
				@cur_y = y
				return
			end

			if ( flags & MK_LBUTTON == 0) # left button doesn't donw
			 	@cur_x = x
			 	@cur_y = y
			  return
			end
			
			dx = x - @cur_x
			dy = y - @cur_y
		
			delta 	= 0.002
			thresh	= 5.0
				
			delta_h = (dx < 0 ? delta : -delta) * (dx.abs > thresh ? thresh : dx.abs)
			delta_z = (dy > 0 ? delta : -delta) * (dy.abs > thresh ? thresh : dy.abs)
		
			if (flags & VK_ALT != 0)
				delta_z = 0
			elsif (flags &  VK_SHIFT!= 0)
				delta_h = 0
			end

			@cur_x = x 
			@cur_y = y 
			rotate(delta_h, delta_z, view)
			view.invalidate
		
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
				zoom(delata_fov, view)
			else
				case key
				when VK_LEFT
					delta_h = 0.025
				when VK_RIGHT
					delta_h = -0.025
				when VK_UP
					delta_z = -0.025
				when VK_DOWN
					delta_z = 0.025
				else
				end
				rotate(delta_h, delta_z, view)
			end
		
			view.refresh
		end


    #--------------------------------------------------------------------------------
    # exit tool case
    #--------------------------------------------------------------------------------
    # The deactivate method is called when the tool is deactivated because a different tool was selected.
		def deactivate(view) 
			puts("deactivate")
			#view.camera=@old_camera
			#Sketchup.active_model.layers[NPLAB::LN_CAMERAS].visible=@b_visible
			#view.refresh	
		end
    
    def onCancel(reason, view)
    	puts("OnCancel:#{reason}")
    	
    	if reason == 2 && NPLAB.get_target_number() == @org_target_numb
    		UI.messagebox("Please check the undo action", MB_OK);
    		Sketchup.active_model.select_tool(nil)
    	end

    	if reason == 0
    		Sketchup.active_model.select_tool(nil)
    	end

    end

		#def onCancel(reason, view)
    #  puts("onCancel")
		#end


    def suspend(view)
      puts("suspend")
      Sketchup.active_model.select_tool(nil)
    end

	
		def rotate(delta_h, delta_z, view)
			camera = view.camera

			eye 		= camera.eye
			target  = camera.target 
			up 				= camera.up


			direction	= camera.direction
			axis      = up.cross(direction)
			direct_up = NPLAB.get_up(Sketchup.active_model.definitions[NPLAB::CN_CAMERA].instances[0])

			t1 = Geom::Transformation.rotation(eye,       axis, delta_z)
			t2 = Geom::Transformation.rotation(eye, direct_up, delta_h)
			

			new_up = up.transform(t2 * t1)
			new_target = target.transform(t2 * t1)
			view.camera.set(eye, new_target, new_up)

		end
	
		def zoom(alpha, view)
			fov= view.camera.fov + alpha
			fov= fov > 120 ? 120 : fov
			fov= fov < 15 ? 15 :  fov
			view.camera.fov= fov

		end

	end
  
end
