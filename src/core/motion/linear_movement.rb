
require "#{File.dirname(__FILE__)}/basic_movement.rb"


module NPLAB
  module Motion
    
    #
    #
    #
    
    class CLinearMovement < CBasicMovement
      attr_accessor :acceleration
      def motion_type()
        return "linear movement"
      end
      
      
      def initialize(options={})
        
        defaults={"p0"     => Geom::Transformation.new, 
                  "v0"     => [1, 0, 0],
                  "a"      => 0}
        options = defaults.merge(options)   
              
        reset(options["p0"], options["v0"], options["a"])
      end
      
      def to_hash()
        hash = {
          "motion_type"   => motion_type(),
          "init_velocity" => init_velocity.to_a, 
          "init_position" => Utils.transf_to_hash(init_position),
          "acceleration"  => acceleration}
        return hash
      end
      
      def self.from_hash(hash)
        p0 = transformation_from_hash(hash["init_position"])
        v0 = Geom::Vector3d.new(hash["init_position"])
        a  = hash["acceleration"]
        mv = CLinearMovement.new
        mv.set(p0, v0, a)
        return mv
      end
      
      
      def set(p0, v0, a)
        @init_velocity= Geom::Vector3d.new(v0) 
        @init_position= Geom::Transformation.new(p0)  
        @acceleration = a 
        return self
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