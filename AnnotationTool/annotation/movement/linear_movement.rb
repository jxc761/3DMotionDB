
require "#{File.dirname(__FILE__)}/basic_movement.rb"


module NPLAB
  module Movement
    
    #
    #
    #
    
    class CLinearMovement < CBasicMovement
      attr_accessor :acceleration
      
      def initialize(p0=Geom::Transformation.new, v0=[1, 0, 0], a=0)
        super(p0, v0)
        @acceleration = a 
      end
 
      def position(t)
        if t == 0
          return @init_position
        end
        
        v0   = init_speed()
        d  = init_direction()   
        s   = v0 * t + 0.5 * @acceleration * t * t
        d.length= s
        offset = Geom::Transformation.new(d)
        return offset * @init_position
      end

    end #end linear motion
   
  end
end