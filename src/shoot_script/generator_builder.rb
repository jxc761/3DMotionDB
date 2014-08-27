module NPLAB
  module Motion
    
    # build movers
    def self.build_movers(types)
      movments = types.collect{ |type|
        build_mover(type)
      }
      return movements
    end
    
    def self.build_mover(type)
      case type
      when "linear_motion"
        mover = CLinearMovement.new
      when "rotation_around_target"
        mover = CRoateAroudPoint.new
      when "rotation_around_axis"
        mover = CRoateAroudAxis.new
      else
        raise "unkown motion type"
      end
      return mover 
    end

    
    # build directions generators
    def self.build_direction_generators(conf_directions)
      generators = conf_directions.collect{ |conf|
        build_directions_generator(conf)
      }
      return generators
    end
    
    def self.build_direction_generator(conf_direction)
      type = conf_direction["direction_specifier"]
      opts = conf_direction["options"]
      
      case type
      when "rand_directions_in_space"
        generator = CDirectionsGeneratorInSpace.new(opts)
      when "rand_directions_on_plane"
        generator = CDirectionsGeneratorOnPlane.new(opts)
      when "regular_directions_in_space"
        generator = CRegularDirectionsGeneratorInSpace.new(opts)
      when "regular_directions_on_plane"
        generator = CRegularDirectionsGeneratorOnPlane.new(opts)
      when "special_directions"
        generator = CSpecificDirectionsGenerator.new(opts)
      end
      return generator
    end #end build_directions_generator
    
    
    # build speed generators
    def self.build_speed_generators(conf_speeds)
      generators = conf_speeds.collect{ |conf_speed|
        CSpeedGenerator.new(conf_speed)
      }
      return generators
    end
    
    
    def self.build_speed_generator(conf_speed)
      return CSpeedGenerator.new(conf_speed)
    end
    
  end
end 