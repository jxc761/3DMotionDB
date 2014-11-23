module NPLAB
  module ShootScriptGenerator

    
    def self.build_shoot_script_generator(conf)
      
      mover       = build_mover(conf.motion_type)
      director    = build_direction_generator(conf.direction)
      speedor     = build_speed_generator(conf.speed)
      duration    = conf.duration
      sample_rate = conf.sample_rate
      generator   = CShootScriptGenerator.new( mover, director, speedor, duration, sample_rate)
      return generator
    end 
  
    # build mover
    def self.build_mover(type)
      case type
      when "linear"
        mover = NPLAB::Motion::CLinearMovement.new
      when "rotation_around_target"
        mover = NPLAB::Motion::CRotateAroudPoint.new
      when "rotation_around_up_axis"
        mover = NPLAB::Motion::CRotateAroundAxis.new
      else
        raise "unkown motion type"
      end
      return mover 
    end

    
    # build directions generators

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
    end #end build_direction_generator
    
    
    # build speed generator

    def self.build_speed_generator(conf_speed)
      return CSpeedGenerator.new(conf_speed)
    end
    
  end
  
  
end 

=begin
    def self.build_movers(types)
      movements = types.collect{ |type|
        build_mover(type)
      }
      return movements
    end
    
    def self.build_speed_generators(conf_speeds)
      generators = conf_speeds.collect{ |conf_speed|
        CSpeedGenerator.new(conf_speed)
      }
      return generators
    end

    def self.build_direction_generators(conf_directions)
      generators = conf_directions.collect{ |conf|
        build_direction_generator(conf)
      }
      return generators
    end
=end
