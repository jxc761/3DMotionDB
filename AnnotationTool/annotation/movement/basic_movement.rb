module NPLAB
  module Movement
  
    # This class is the interface of the all movement class
    #
    # == Example
    #
    # # init_position: Transformation
    # # init_veloctiy: Vector3d/Array/Point3d
    # movement = CLinearMovement(init_position, init_velocity)
    #
    # postion = movement.get_position(t)
    # location = movement.location(t)
    #
    # == Note
    # 

    class CBasicMovement
      
      # ---------------------------------------------------
      # THE MOST IMPORTANT METHOD MUST TO BE IMPLEMENTED 
      #                IN THE SUBCLASS
      # ---------------------------------------------------
      #
      # This function is to get the position at time t.
      #
      # Return:
      # A Transformation instance which describes the location and orientation
      #
      def position(t)
        raise "This is an interface"
      end
     
    
      #
      # Transforamtion init_position, the the intial position of the movement
      # Vector3d/Point3d/Array  init_velocity, the initial velocity which discribe the speed and direction.
      #
      # attr_accessor :@init_position, :@init_velocity
    
      def initialize(p0=Transformation.new, v0=[1, 0, 0])
        @init_velocity= Geom::Vector3d.new(v0) # default value 
        @init_position= Geom::Transformation.new(p0)  
      end
      
      #
      # attribute accessor
      #
      def init_position
        #puts "init_position"
        @init_position
      end
      
      def init_position=(p0)
        #puts "init_position="
        @init_position = Geom::Transformation.new(p0)
      end
      
      def init_velocity
        #puts "init_veloctiy"
        @init_velocity
      end
      
      def init_velocity=(v0)
        #puts "init_veloctiy="
        @init_velocity= Geom::Vector3d.new(v0)
      end
      
      # 
      # the initial speed, direction and location
      #
      def init_speed
        @init_velocity.length
      end
      
      def init_speed=(speed)
        @init_velocity.length=speed
      end

      def init_direction
        @init_velocity.normalize
      end
            
      def init_location
        @init_position.origin
      end
      
      #
      # following methods to get the orientation and the location of at time t
      #
      def location(t)
        return position(t).origin
      end
      
      def xaxis(t)
        return position(t).xaxis
      end
      
      def yaxis(t)
        return position(t).yaxis
      end
      
      def zaxis(t)
        return position(t).zaxis
      end
      
   end # end class
    

  end #end module Motion
  
end
