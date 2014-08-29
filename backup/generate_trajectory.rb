
require "#{File.dirname(__FILE__)}/libs.rb"
module NPLAB

  module ShootingScript
   
      
    class CShootingScriptConf
      attr_accessor :motion_types, :directions, :speeds, :duration, :sample_rate, :seed
      
      def initialize(options={})
        defaults = {
          "motion_types" => [],
          "directions" => [],
          "speeds" => [],
          "duration" => 0,
          "sample_rate" => 1,
          "seed" => Time.now.to_i
        }
        
        options = defaults.merge(options)
        
        @motion_types = options["motion_type"]
        @directions   = options["directions"]
        @speeds       = options["speeds"]
        @duration     = options["duration"]
        @sample_rate  = options["sample_rate"]
        @seed         = options["seed"]
      end
      
    end
    
    def self.generate_shooting_scripts(conf)
      mover     = build_mover(conf["motion_typ"])                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
      director  = build_director(conf["dirction"]["direction_specifier"])
      speedor   = build_speedor(conf["speed"])
    end
      info = BasicJson.load(fn_info)
    def self.load_camera_target_setting_info(fn_info)
    end
    
    class CSceneSettingInfo
      def load()
      end
      
      def save()
      end
      
      def initialize(info)
        @cameras = info["cameras"]
        @targets = info["targets"]
        @pairs   = info["pairs"]
      end
      
      def pair(index)
        
      end
    end
    
    #
    # entrance function
    #
    def self.generate_trajectories(pz_input, fn_conf, dn_output)
      check_arguments(pz_input, fn_conf, dn_output)
      
      # load in the configuration of trajectory generation
      confs = load_conf(fn_conf)
      
      # if there are many configurations, then make an subdirectory for each configuration.
      # else take the <dn_output> for the root output directory.
      dn_outputs = []
      
      if confs.instance_of?(Array)
        # make a directory under <dn_output> for each configuration
       
        (0...confs.size).each{ |index|
          subdir = File.join(dn_output, "conf#{index}")
          Dir.mkdir(subdir)
          dn_outputs << subdir
        }
      else
        confs = [confs]
        dn_outputs = [dn_output]
      end
      
       
      # list camera-target setting files
      cts_list = [pz_input] 
      if File.directory?(pz_input)
         cts_list=Dir['/usr/*.json']
      end
      
      confs.each_index{ |conf_index|
        conf = confs[conf_index]
        dn_cur_root_ouptut= dn_outputs[conf_index]
        
        cts_list{ |fn_cts|
          
          cts = BasicJson.load_from_json(fn_cts) 
          name  = File.filename(fn_cts) 
          dn_cur_output = File.join(dn_cur_root_output, name)
          Dir.mkdir(dn_cur_output)
           
          self.generate_trajectories_for_one_cts(cts, conf, dn_cur_output)
        }
      }
    end
    
    def self.generate_tarjectories_file(fn_input, fn_conf, dn_output)
       cts  = BasicJson.load_from_json(fn_cts)
       conf = BasicJson.load_from_json(fn_conf)
       generate_trajectories(cts, conf, dn_output)   
    end
    
    def generate_signle(cts, conf, dn_output)
      mover     = build_mover(conf["motion_type"])
      director  = build_director(conf["dirction"]["direction_specifier"])
      speedor   = build_speedor(conf["speed"])
      
      duration    = conf["duration"]
      sample_rate = conf["sample_rate"]
      cts[pairs].each{
        camera = 1
        target = 1
        directions = director.get_directions()
          directions.each{ |direction|
            speeds = speedor.get_speeds()
            speeds.each{|speed|
            reset_mover(mover, camera_location, camera_up, target_location, direction, speed)
            trajectory = mover.generate_trajectory(duration, sample_rate)
            write_trajectory(trajectory, filename)
        }
      }
      }

      
    end
    
    class CShootingScriptGenerator
      
      def initialize(movers, directors, speedors, duration, sample_rate)
        @m_movers       = movers
        @m_directors    = directors
        @m_speedors     = speedors
        @m_duration     = duration
        @m_sample_rate  = sample_rate
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
      if mv.instance_of CRoateAroudPoint
        mv.origin = Geom::Point3d.new(target_location)
        mv.axis   = nil
      end
      
      if mv.instance_of CRoateAroudAxis
        mv.origin = Geom::Point3d.new(target_location)
        mv.axis   = Geom::Vector3d.new(camera_up)
      end
      return mv
    end

      def generate_trajectories(c, c_up, target, dn_output)
        ccs = CShootingScriptGenerator.build_coordinate_system(c, c_up, target) # camera_coordinate_system
        directions = @m_directors.get_directions(ccs)
        trajectories = []
        directions.each{ |d0|
          speeds = @m_speedor.get_speeds()
          speeds.each{ |s0|
           reset_mover(@m_mover, c, c_up, target, d0, s0)
           trajecty = get_one_trajectory(@m_mover, target, @duration, @sl)
           trajecties[]
           
          }
        }
        
      end
    # ------------------------------------------------------
    # Assistance functions
    # ------------------------------------------------------
    # Args:
    #   target: Array
    #   mv : CMovement
    #   duration: int 
    #   sl: int sample rate samples/s
    # 
    def self.get_one_trajectory(mv, target, duration, sl)
      target = to_m(target.to_a)
      nframe = duration * sl
      dt     = 1.0 / sl
      
      trajectory = []
      (0...nframe).each{ |iframe|
        t = dt * iframe
        eye_t = to_m( mv.location(t) )
        up_t  = to_m( mv.zaxis(t) )
        
        hash  = { 
          "time" => t, 
          "camera_location" => eye_t,
          "camera_up" => up_t,
          "target_position" => target,
        }
        
        trajectory << hash
      }
      
      return trajectory
      
    end

    end
    
    def self.generate_trajetory(cts, conf, dn_output)
    
    
    private
    def self.check_arguments(pz_input, fn_conf, dn_output)
      # check exist of files
      unless (File.exist?(pz_input) && File.exist?(fn_conf) && File.exist?(File.dirname(dn_output))
        raise "Path setting error"
      end
      
      unless File.directory?(dn_output)
        Dir.mkdir(dn_output)
      end
    end # end method
    
    def self.load_conf(fn_conf)
      conf = BasicJson.load_from_json(fn_conf) 
      
      if conf.instance_of?(Array)
        puts "configurations"
      end
      
      if conf.instance_of?(Hash)
        puts "configuration"
      end
      
      return conf
      
    end
    def self.build_uvw_system(v, w)
      v = Geom::Vector3d.new(v)
      w = Geom::Vector3d.new(w).normalize
      u = v.cross(w).normalize
      v = w.cross(u).normalize
      return [u, v, w]
    end
    

  end
end


=begin
    def self.load_shoot_script_conf(fn_conf)
        confs = BasicJson.load(fn_conf)
        unless confs.instance_of?(Array)
          confs = [confs]
        end
        
        configurations = confs.collect{|conf|
          unless conf["motion_types"].instanc_of?(Array)
            conf["motion_types"] = [conf["motion_types"]]
          end 
          
          unless conf["directions"].instance_of?(Array)
            conf["directions"] = [conf["directions"]]
          end
          
          unless conf["speeds"].instance_of?(Array)
            conf["speeds"] = [conf["speeds"]]
          end 
          
          mover     = build_mover(conf["motion_typ"])                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
          director  = build_director(conf["dirction"]["direction_specifier"])
          speedor   = build_speedor(conf["speed"])
        }
        
        return configurations
        
    end
        def from_hash(conf)
        @motion_types = conf["motion_types"]
        @directions   = conf["directions"]
        @speeds       = conf["speeds"]
        @duration     = conf["duration"]
        @sample_rate  = conf["sample_rate"]
        @seed         = conf["seed"]
        @dn_output    = conf["dn_path"]
      end 
      
=end
