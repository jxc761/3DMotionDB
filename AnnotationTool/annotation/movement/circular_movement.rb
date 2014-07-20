require "#{File.dirname(__FILE__)}/basic_movement.rb"


module NPLAB
  module Movement
    
    class CCircularMovement < CBasicMovement
      
      def initialize(p0=Geom::Transformation.new, v0=[1, 0, 0], origin=[0, 0, 0], axis=nil)
        @init_position  = Geom::Transformation.new(p0)
        @origin         = Geom::Point3d.new(origin)
       
        if axis == nil
          @center = @origin
        else
          va = Geom::Vector3d.new(axis).normalize
          po = @init_position.origin - @origin
          s  = po.dot(va) 
          @center = Geom::Point3d.linear_combination(s, va.to_a, 1, @origin)
        end
        
        # depends on the @center and @init_position
        @init_velocity = project_v0(v0)

      end
      
      def origin
        return @origin
      end
      
      def center 
        return @center
      end
      
      def init_angular_speed
        return init_speed * rotation_radius
      end   
      
      def init_angular_speed=(w)
        speed = w / rotation_radius
        @init_velocity.length=speed
      end
      
      def init_velocity=(v0)   
        puts "init_velocity="
         @init_velocity = project_v0(v0)
      end
      
      def rotation_radius
        return @center.distance(init_location)
      end
      
      def radius
        return @origin.distance(init_location)
      end
      
      def rotation_axis
         cp = @center - @init_position.origin
         @init_velocity.cross(cp).normalize
      end
      
      
      def position(t)
         if t == 0
          return @init_position
        end
        
        phi = init_angular_speed * t
        rotation = Geom::Transformation.new(@center, rotation_axis, phi)
        return rotation * @init_position
      end
      
      
      private
      def project_v0(v0)
        v0 = Geom::Vector3d.new(v0)  
        p0 = @init_position.origin
        vn = (@center - p0).normalize
        s  = v0.dot(vn) 
        return Geom::Vector3d.linear_combination(1, v0, -s, vn)
      end
     
     
    end # end class
    
  
  end # end module
  
end