module NPLAB
  
  module Render
    
    
    class CSURender 
      
      # Attributes: 
      # CShootScript script
      # CSURenderSetting setting
      # string output_path
      #
      # Method:
      # CSURender.new(CSURenderConf conf, CShootScript script, string dn_output)
      def initialize(c, scr, dn)
        @conf         = c
        @script       = scr
        @dn_output    = dn
        @cur_frame    = 0
      end
      
      def render()
        @cur_frame    = 0
        
        
        NPLAB::Utils.hide_annotation()
        set_render_env()
        
        Sketchup.active_model.active_view.animation= self
      end

  
      def set_render_env()
        model = Sketchup.active_model
        
  
        @conf.render_options.each_pair{ |key, value|
          model.rendering_options[key] = value
        }
        
        @conf.shadow_info.each_pair{ |key, value|
          model.shadow_info[key] = value
        }
        
      end
      
      def nextFrame(view)
        camera_tr = @script.camera_tr
      
      
        if @cur_frame >= camera_tr.length
          exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")
          return false
        end

        # current setting
        target = @script.target.position.origin
        eye    = camera_tr.location(@cur_frame)
        up     = camera_tr.up(@cur_frame)
      
        view.camera.set(eye, target, up)
        view.camera.image_width   = @conf.film_width
        view.camera.aspect_ratio  = @conf.aspect_ratio
        view.camera.fov           = @conf.fov
      
        # save image out
        filename     = File.join(@dn_output, "#{@cur_frame}.jpg")
        view.write_image(filename, @conf.image_width, @conf.image_height, true, 1.0)

        # update
        @cur_frame += 1
        return true
      end

    end
    
  end
  
end