
module NPLAB

  def self.build_shoot_script_generator(conf)
    mover       = build_movers(conf.motion_type)
    director    = build_directions_generators(conf.direction)
    speedor     = build_speed_generators(conf.speed)
    duration    = conf.duration
    sample_rate = conf.sample_rate
    generator   =  CShootScriptGenerator.new( mover, director, speedor, duration, sample_rate)
    return generator
  end 
  
  class CShootScriptGenerator
    
    attr_accessor :mover, :director, :speedor, :duration, :sample_rate 
    
    def initialize(m, d, s, duration, sr)
      @mover       = m
      @director    = d
      @speedor     = s
      @duration    = duration
      @sample_rate = sr
    end
    
    def generate_shoot_scripts(camera, target)
      camera_location     = camera["position"]["origin"]
      camera_up           = camera["position"]["zaxis"] 
      target_location     = target["position"]["origin"]
      
      # camera_coordinate_system
      ccs = build_coordinate_system(camera_location, camera_up, target_location) 
      
      directions = director.get_directions(ccs)
      scripts = []
      
      directions.each{ |d0|
        speeds = speedor.get_speeds()
        sscripts = []
        speeds.each{ |s0|
          mover  = reset_mover(mover, camera_location, camera_up, target_location, d0, s0)
          script = CShootScript.new
          
          script.target = target
          script.camera = camera
          script.camera_tr = generate_trajectory(mover, @duration, @sample_rate)
          sscripts << script
        }
        scripts << sscripts
      }
      return scripts
    end
 
  
    def self.build_coordinate_system(c, c_up, target)
      co = Geom::Point3d.new(c)
      pt = Geom::Point3d.new(target)
      cy = cz.cross(pt-co).normalize
      cx = cy.cross(cz).normalize
      cz = Geom::Vector3d.new(c_up).normalize
      return Geom::Transformation.new(cx, cy, cz, co)
    end  
 
           
    def self.reset_mover(mv, camera_location, camera_up, target_location, d0, s0)
    
      p0 = Geom::Point3d.new(camera_location)
      v0 = Geom::Vector3d.new(d0)
      v0.length=s0
    
      mv.p0 = p0
      mv.v0 = v0
      if mv.instance_of? CRoateAroudPoint
        mv.origin = Geom::Point3d.new(target_location)
        mv.axis   = nil
      end
    
      if mv.instance_of? CRoateAroudAxis
        mv.origin = Geom::Point3d.new(target_location)
        mv.axis   = Geom::Vector3d.new(camera_up)
      end
      return mv
    end


    def self.generate_trajectory(mover, duration, sample_rate)
      tr            = CTrajectory.new
      tr.motion     = mover.to_hash
      tr.duration   = duration
      tr.sample_rate= sample_rate
      
      n  = duration * sample_rate + 1
      dt = 1.0 / sample_rate
      tr.trace =(0...n).collect{ |i| mover.position(dt * n) }   
      return tr
    end
 
  end

end