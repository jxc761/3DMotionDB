require "#{File.dirname(__FILE__)}/basic_movement.rb"


module NPLAB
  module Motion
    
    class CCircularMovement < CBasicMovement
      attr_accessor :origin, :axis

      def initialize(options)
        defaults={"p0"     => Geom::Transformation.new, 
                  "v0"     =>[1, 0, 0],
                  "origin" =>[0, 0, 0], 
                  "axis"   =>nil}
                  
        options = defaults.merge(options)
        
        reset(options["p0"], options["v0"], options["origin"], options["axis"])
      end
      
      
      def motion_type
        return "circular movement"
      end
      def to_hash()
        hash = {
          "motion_type"   => motion_type
          "init_velocity" => @init_velocity.to_a, 
          "init_position" => Utils.transf_to_hash(@init_position),
          "origin"        => @origin.to_a}
          
        if @axis
          hash["axis"] = @axis.to_a
        end
        
        return hash
      end
      
      def self.from_hash(hash)
        v0 = hash["init_velocity"]
        p0 = Utils.transf_from_hash(hash["init_position"])
        o = hash["origin"]
        a = hash["axis"]
        mv = CCircularMovement.new()
        mv.set(v0, p0, o, a)
        return mv
       
      end
 
      def rotation_axis
         cp = center - @init_position.origin
         init_linear_velocity_direction.cross(cp).normalize
      end
      
      def set(p0, v0, origin, axis=nil)

        @init_position  = Geom::Transformation.new(p0)
        @init_velocity  = Geom::Vector3d.new(v0)
        @origin         = Geom::Point3d.new(origin)
        @axis           = axis ? Geom::Vector3d.new(axis) : nil
        return self
      end
      
      def center  
        if axis == nil
          c = @origin
        else
          va = Geom::Vector3d.new(axis).normalize
          po = @init_position.origin - @origin
          s  = po.dot(va) 
          c = Geom::Point3d.linear_combination(s, va.to_a, 1, @origin)
        end
        return c
      end
      
      def init_angular_speed
        return init_linear_speed * rotation_radius
      end   
      
#     def init_angular_speed=(w)
#       speed = w / rotation_radius
#       @init_velocity.length=speed
#     end
      
      def init_linear_velocity
        project_v0(@init_velocity)
      end
      
      def init_linear_speed
        init_linear_velocity.length
      end
      
      def init_linear_velocity_direction
        init_linear_velocity.noramlize
      end
      #
      #def init_velocity=(v0)   
      #  puts "init_velocity="
      #   @init_velocity = project_v0(v0)
      #end
      #
      
      def rotation_radius
        return center().distance(init_location)
      end
      
      def radius
        return @origin.distance(init_location)
      end

      def position(t)
         if t == 0
          return @init_position
        end
        
        phi = init_angular_speed * t
        rotation = Geom::Transformation.new(center, rotation_axis, phi)
        return rotation * @init_position
      end
      
      
      private
      def project_v0(v0)
        v0 = Geom::Vector3d.new(v0)  
        p0 = @init_position.origin
        vn = (center - p0).normalize
        s  = v0.dot(vn) 
        return Geom::Vector3d.linear_combination(1, v0, -s, vn)
      end
     
     
    end # end class
    
    class CRoateAroudPoint < CCircularMovement 
      def motion_type()
        return "rotation around point"
      end
      
    end
    
    class CRoateAroundAxis < CCircularMovement
      def motion_type()
        return "rotation around axis"
      end
    end
  
  end # end module
  
end