require "#{File.dirname(__FILE__)}/basic_movement.rb"


# Notes 
#  Geom::Transformation.rotation follows "right hand rule"
#   Transformation.rotation(center, axis, angle)
#   
#   If your thumb points in the direction of rotation axis, the fingers point to the rotation direction 
#   For example, say center is at the origin (0, 0, 0), axis is along z-axis (0, 0, 1)
#   If the angle is positive, then the rotate direction will follow  x -> y 
#   If the angle is negative, then the rotate direction will follow  x ->-y
# 
# 
#To verify it, you can run following code
#center = Geom::Point3d.new([0, 0, 0]);
#axes  = [ [ 1,  0,  0], [-1,  0, 0],
#          [ 0,  1,  0], [ 0, -1, 0],
#          [ 0,  0,  1], [ 0,  0, -1]]
#
#angles = [ 3.14/4, -3.14/4]
#point = Geom::Point3d.new([1, 1, 0])
#
#axes.each{ |axis| 
#  angles.each{ |angle|
#    transf = Geom::Transformation.rotation(center, axis, angle)
#    pt = point.transform(transf)
#
#    puts("----------------")
#    puts("angles: #{angle}" )
#    puts("axis :  #{axis[0]}, #{axis[1]}, #{axis[2]} ")
#    puts("pt   :  #{pt[0]}, #{pt[1]}, #{pt[2]} ")
#  }
#}


module NPLAB
  module Motion
    class CCircularMovement < CBasicMovement
      attr_accessor :origin, :axis

      def initialize(options={})
        defaults={"p0"     => Geom::Transformation.new,  
                  "v0"     =>[1, 0, 0],
                  "origin" =>[0, 0, 0], 
                  "axis"   =>nil}
                  
        options = defaults.merge(options)
        
        set(options["p0"], options["v0"], options["origin"], options["axis"])
      end
      
      
      def motion_type
        return "circular movement"
      end
      def to_hash()
        hash = {
          "motion_type"   => motion_type,
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
        if @axis != nil
          return @axis
        end
         cp = center - @init_position.origin
         init_linear_velocity_direction.cross(cp).normalize
      end
      
      def set(p0, v0, origin, axis=nil)

        @init_position  = Geom::Transformation.new(p0)
        @init_velocity  = Geom::Vector3d.new(v0)
        @origin         = Geom::Point3d.new(origin)
        @axis           = axis != nil ? Geom::Vector3d.new(axis) : nil
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
      
      # if the rotation direction follows right-hand-rule, init_angular_velocity > 0, otherwise, init_angular_velocity < 0
      def init_angular_velocity
        z = rotation_axis()
        v = init_linear_velocity_direction()
        d = z.cross(v) # if d points to the center, init_anglar_velocity > 0, 
        
        to_c = center - @init_position.origin
        sign_d =  to_c.dot(d) > 0 ?  1 : -1
        return sign_d * init_linear_speed / rotation_radius
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
        init_linear_velocity.normalize
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
        
        phi = init_angular_velocity * t
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
    
    class CRotateAroudPoint < CCircularMovement 
      def motion_type()
        return "rotation_around_point"
      end
      
    end

    class CRotateAroundAxis < CCircularMovement
      def motion_type()
        return "rotation_around_axis"
      end
    end
  
  end # end module
  
end