
module NPLAB
  module ShootScriptGenerator

    class CShootScriptGenerator
    
      #attr_accessor :mover, :director, :speedor, :duration, :sample_rate 
    
      def initialize(m, d, s, duration, sr)
        @mover       = m
        @director    = d
        @speedor     = s
        @duration    = duration
        @sample_rate = sr
      end
    
      def generate_shoot_scripts(camera, target)
        camera_location     = camera.position.origin
        camera_up           = camera.position.zaxis
        target_location     = target.position.origin
        
        # camera_coordinate_system
        ccs = CShootScriptGenerator.build_coordinate_system(camera_location, camera_up, target_location) 
      
        directions = @director.generate_directions(ccs)
        scripts = []
      
        directions.each{ |d0|
          speeds = @speedor.generate_speeds()
          sscripts = []
          speeds.each{ |s0|
            CShootScriptGenerator.reset_mover(@mover, camera_location, camera_up, target_location, d0, s0)
            
            camera_tr = CShootScriptGenerator.generate_trajectory(@mover, @duration, @sample_rate)
            
            script = NPLAB::CoreIO::CShootScript.new(camera, target, camera_tr)
            sscripts << script
          }
          scripts << sscripts
        }
        return scripts
      end
 
  
      def self.build_coordinate_system(c, c_up, target)
        co = Geom::Point3d.new(c)
        pt = Geom::Point3d.new(target)
        cz = Geom::Vector3d.new(c_up).normalize
        
        cy = cz.cross(pt-co).normalize
        cx = cy.cross(cz).normalize
        
        return Geom::Transformation.new(cx, cy, cz, co)
      end  
 
           
      def self.reset_mover(mv, camera_location, camera_up, target_location, d0, s0)
    
        p0 = Geom::Point3d.new(camera_location)
        v0 = Geom::Vector3d.new(d0)
        v0.length=s0

        if mv.instance_of? NPLAB::Motion::CLinearMovement
          mv.set(p0, v0, 0)
        end
        
        if mv.instance_of? NPLAB::Motion::CRotateAroudPoint
          origin = Geom::Point3d.new(target_location)
          mv.set(p0, v0, origin)
        end
    
        if mv.instance_of? NPLAB::Motion::CRotateAroundAxis
          
          origin = Geom::Point3d.new(target_location)
          axis   = Geom::Vector3d.new(camera_up)
          mv.set(p0, v0, origin, axis)
        end
        
        return mv
      end


      def self.generate_trajectory(mover, duration, sample_rate)
        motion_info = mover.to_hash
        duration    = duration
        sample_rate = sample_rate
      
        n  = duration * sample_rate + 1
        dt = 1.0 / sample_rate
        trace =(0...n).collect{ |i| mover.position(dt * n) }   
        return NPLAB::CoreIO::CTrajectory.new(motion_info, duration, sample_rate, trace)
      end
 
    end
  end
end