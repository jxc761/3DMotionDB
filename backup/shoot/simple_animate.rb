module NPLAB
  class CShootScirpt
    def get_camera_position(t)
      
    end
    

    def get_camera_up(t)
      
    end
    
    def get_focus_position(t)
      
    end
    
    def get_fov(t)
      
    end
    

  end
  
  class CSUShooter
    def initialize(script)
      @script    = script
      @cur_frame  = 0
    end

    def nextFrame(view)
      if @cur_frame >= scripts.size()
          return false
      end
  
      # current setting
      eye    = scripts[cur_frame]["eye"]
      target = scripts[cur_frame]["target"]
      up     = scripts[cur_frame]["up"]
      fov    = scripts[cur_frame]["fov"]
  
  
      view.camera.set(eye, target, up)
      view.camera.fov = fov
  
      # save image out
      filename        = scripts[cur_frame]["path"]
      image_width     = scripts[cur_frame]["image_width"]
      image_height    = scripts[cur_frame]["image_height"]
      view.write_image(filename, @image_width, @image_height, true, 1.0)
  
      # update
      cur_frame += 1
      return true
    end     
  end
end