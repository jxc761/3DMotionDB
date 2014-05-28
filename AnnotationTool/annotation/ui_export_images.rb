

require "#{File.dirname(__FILE__)}/annotation.rb"
#load("/Users/Jing/Library/Application Support/SketchUp 2013/SketchUp/Plugins/annotation/ui_export_images.rb")



class FixationAnimation
	def initialize(export_opts)
		model=Sketchup.active_model
		view = model.active_view
		
		
		@image_width        = export_opts["width"]
		@image_height       = export_opts["height"]
		@fov                = export_opts["fov"]
		@fps                = export_opts["fps"]
		@path_to_save_to    = export_opts["path_to_save_to"]
		@duration           = export_opts["duration"]
        
        @connections        = export_opts["pairs"]
        @mts                = export_opts["mts"]
		
		
		@nframes            = (@duration * @fps).to_i
		
        
        Dir.mkdir(@path_to_save_to) unless File.directory?(@path_to_save_to)
		
		@cur_connection_index   = 0
		@cur_frame_index        = 0
		@cur_mts_index          = 0
		
		clayer = model.layers[NPLAB::LN_CAMERAS]
		if clayer != nil
			clayer.visible= false
		end
		
		tlayer = model.layers[NPLAB::LN_TARGETS]
		if tlayer != nil
			tlayer.visible= false	
		end
		
		if startNewConnection()
		  startNewDirection()
		end
	end
	
	def startNewConnection()
		if @cur_connection_index >= @connections.size
			return false
		end
		
		@cur_observer   = @connections[@cur_connection_index][0]
		@cur_target 	= @connections[@cur_connection_index][1]
		
		observerId      = NPLAB.get_id(@cur_observer)
		targetId        = NPLAB.get_id(@cur_target) 
        
		@cur_prefix = "C#{observerId}_F#{targetId}_"
		@cur_obs_org_transform = @cur_observer.transformation
		
        @cur_mts = @mts[@cur_connection_index]
		return true
	end
	
	def startNewDirection() 
		@cur_observer.transformation= @cur_obs_org_transform
		@cur_dir= File.join(@path_to_save_to, @cur_prefix + "D#{@cur_mts_index}")
		puts @cur_dir
		if  File.exists?(@cur_dir)
		  return false
		else
		  Dir.mkdir(@cur_dir)
		  return true
		end
	end

	def nextFrame(view)
		# if all animations are finished or no connection need to be animated, return false
		if @cur_frame_index >= @nframes || @cur_mts_index >= @cur_mts.size || @cur_connection_index >= @connections.size 
			return false
		end
		
		
		eye 	= NPLAB.get_eye_position(@cur_observer)
		up  	= NPLAB.get_up(@cur_observer)
		target 	= NPLAB.get_target_position(@cur_target)

		view.camera.set(eye, target, up)
		
		# save image out
		filename=File.join(@cur_dir, "#{@cur_frame_index}" + ".jpg")
		Sketchup.set_status_text("Exporting frame #{@cur_frame_index} to #{filename}")
		begin
			view.write_image(filename, @image_width, @image_height, true, 1.0)
		rescue
			UI.messagebox("Error exporting animation frame.  Check animation parameters and retry.")
			raise
		end
		
		
		# refresh the design window
		view.show_frame()
		
		# move observer
		cur_transform = @cur_observer.transformation
		@cur_observer.transformation= @cur_mts[@cur_mts_index] * cur_transform

		#update
		@cur_frame_index += 1
		if @cur_frame_index >= @nframes
		  # call finish_one_direction
		  @cur_observer.transformation= @cur_obs_org_transform
		  @cur_mts_index +=1
		 
		  if @cur_mts_index >= @cur_mts.size
			# call finish_one_pair
			@cur_connection_index +=1
			if @cur_connection_index >= @connections.size
			  return false
			end
			startNewConnection()
			@cur_mts_index = 0
		  end
		  
		  startNewDirection()
		  @cur_frame_index = 0
		end     
		return true
	end
end
