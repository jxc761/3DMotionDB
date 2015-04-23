require "#{File.dirname(__FILE__)}/annotation.rb"
require "#{File.dirname(__FILE__)}/ui_small_tools.rb"

########################

########################
module NPLAB

  class CTargetTool

    def activate()
      puts("activate")
      Sketchup.active_model.start_operation("active edit target")

      store_status()   
      # show targets layer
      @tlayer = Sketchup.active_model.layers[NPLAB::LN_TARGETS]
      unless @tlayer
        @tlayer = Sketchup.active_model.layers.add(NPLAB::LN_TARGETS)
      end
      @tlayer.visible=true
      
      
			@target_def         = NPLAB.get_definition(Sketchup.active_model, NPLAB::CN_TARGET, NPLAB::FN_TARGET)
      @org_target_number  = NPLAB.get_target_number()
      #@target_number      = NPLAB.get_target_number()

			# initialize the status 
			@clayer.visible= false	 # clayer : camera_layer
      camera_def     = NPLAB.get_definition(Sketchup.active_model, NPLAB::CN_CAMERA, NPLAB::FN_CAMERA)
			@active_camera = camera_def.instances[0]
			
      # 
      # @cur_target = Sketchup.active_model.active_view.camera.target
      @cur_target = Sketchup.active_model.active_view.guess_target
			@cur_x      = nil
			@cur_y      = nil
			@cur_fov    = @org_fov
      #@cur_trans_time = 0.5
      @redostate = false
      Sketchup.active_model.active_view.refresh
		  Sketchup.active_model.commit_operation
		end
	
		def draw(view)
			# for debug
			if @active_camera == nil
				#UI::messagebox("error")
				return
			end	
			# end for debug
      
      camera = Sketchup::Camera.new
			up = NPLAB.get_up(@active_camera)
			eye = NPLAB.get_eye_position(@active_camera)
      camera.set(eye, @cur_target, up);
      camera.fov=@cur_fov
      view.camera=camera

      
      #view.camera.set(eye, @cur_target, up)	
			#view.camera.fov=@cur_fov
			
		end
	
		def onLButtonUp(flags, x, y, view)
      
			Sketchup.active_model.start_operation("add target")
      new_target = add_target(x, y, view)
			if new_target != nil
        #@target_number += 1
				@cur_target = NPLAB.get_target_position(new_target)	
      end
      Sketchup.set_status_text "#focal points: #{NPLAB.get_target_number()}"
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


    #--------------------------------------------------------------------------------
    # exit tool case
    #--------------------------------------------------------------------------------
		def deactivate(view)
      puts("deactivate")
      
      Sketchup.active_model.start_operation("exit target tool")
		  Sketchup.active_model.active_view.camera.set(@org_eye, @org_target, @org_up)
		  Sketchup.active_model.active_view.camera.fov= @org_fov

      unless @clayer.deleted? 
         @clayer.visible= true
      end
      
      unless @tlayer.deleted? 
        @tlayer.visible= true
      end
      Sketchup.active_model.commit_operation

		end
    
		def onCancel(reason, view)
      puts("onCancel")
      if reason == 0
			  Sketchup.active_model.select_tool(nil)
      end
      
      if reason == 2 && @org_target_number < NPLAB.get_target_number()
            Sketchup.set_status_text "#focal points: #{NPLAB.get_target_number() - 1}"
            return
      end
          
		end
#    
    def suspend(view)
      puts("suspend")
      Sketchup.active_model.select_tool(nil)
    end
    
    
    #----------------------------------------------------------------------------
		# store & restore the status
		#-------------------------------------------------------------------------------
		def store_status()
			# store the camera information
			model =  Sketchup.active_model
			camera = Sketchup.active_model.active_view.camera
			@org_eye 	  = Geom::Point3d.new(camera.eye)
			@org_up  	  = Geom::Vector3d.new(camera.up)
			@org_target = Geom::Point3d.new(camera.target)
			@org_fov    = camera.fov
		
			# store the layer visibility information
			@clayer = model.layers[NPLAB::LN_CAMERAS]
			#if @clayer == nil
			#	@clayer	= model.layers.add(NPLAB::LN_CAMERAS)
			#end
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
			
			transformation = NPLAB.get_transf(x, y, view)
			new_target = NPLAB.new_instance(Sketchup.active_model, @target_def, transformation, NPLAB::LN_TARGETS)
      #@cur_trans_time = 0
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
      #@cur_trans_time = 0
		end
	
		def zoom(alpha)
			@cur_fov= @cur_fov + alpha
			@cur_fov = @cur_fov > 120 ? 120 : @cur_fov
			@cur_fov = @cur_fov < 15 ? 15 : @cur_fov
		end

	end
  
end
