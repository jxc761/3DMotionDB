module NPLAB
  
  module Shoot
    
    class CCameraOperator < CSimpleAnimate
      def shoot()
        @org_camera = Sketchup.active_model.active_view.camera.copy
        Sketchup.active_model.active_view.animation=self
      end

      def stop()
        Sketchup.active_model.active_view.camera = @org_camera
        Sketchup.active_model.active_view.animation=nil
      end      
    end
    
    class 
    
    
     
    
    module ShootScript
    class CShootScript
      
      def camera_location(t)
        
      end
      
      def camera_up(t)
        
      end
      
      def target(t)
        
      end
      
      def to_hash()
        
      end
      
      def from_hash()
        
      end
      
    end
    
    class Shotter
      
    end
    
  end
  

    
  end
  
end