module NPLAB
 
    
  class CRender
    def self.render(script, setting, output_path)
      raise "This is an interface!"
    end
  end
  
  
  class CSURender < CRender
    #
    # Attributes: 
    # CShootScript script
    # CSURenderSetting setting
    # string output_path
    #
    # Method:
    # CSURender.render(CShootScript script, CSURenderSetting setting, string output_path)
    #
    # CSURender.stop_render()
    #
    def self.render(script, setting, output_path)
      render = self.new
      render.script       = script
      render.setting      = setting
      render.output_path  = output_path
      render.cur_frame    = 0
      
      Sketchup.active_model.active_view.animation = render
      
    end 
    
    def self.stop_render
       Sketchup.active_model.active_view.animation = nil
    end
    
    
    def nextFrame(view)
      camera_tr = @script.camera_tr
      
      
      if @cur_frame >= camera_tr.length
        return false
      end

      # current setting
      target = @script.target_location
      eye    = camera_tr.location(@cur_frame)
      up     = camera_tr.up(@cur_frame)
      
      view.camera.set(eye, target, up)
      view.camera.image_width   = @setting.film_width
      view.camera.aspect_ratio  = @setting.aspect_ratio
      view.camera.fov           = @setting.fov
      
      # save image out
      filename     = File.join(@output_path, "#{@cur_frame}.jpg")
      view.write_image(filename, @setting.image_width, @setting.image_height, true, 1.0)

      # update
      cur_frame += 1
      return true
    end
    
    
    
    private 
    def initialize()
      @script = nil
      @setting = nil
      @output_path = ""
      @cur_frame = -1
    end
    
  end
  
  
end