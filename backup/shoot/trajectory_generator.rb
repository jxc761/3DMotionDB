module NPLAB
  module Movement

    class CTrajectoryGenerator
     
      def initialize(conf)
        @m_ers = build_movers(conf["motion_types"]) 
        @d_ers = build_directions_generators(conf["directions"])
        @s_ers = build_get_speeds_generators(conf["speed"])
        @duration = conf["duration"]
        @sample_rate = conf["sample_rate"]
      end
      
      def set(mover, director, speedor)
        @mover = mover
        @direction_generator = director
        @direction
      end
      
      def generate(camera_location, camera_up, target_location)
        c0 = Geom::Point3d.new(camera_location)
        v  = camera.up
        w  = c0 - target
        
        u, v, w = Utils.uvw_system(v, w)
        camera_coordinate_system  = Geom::Transformation.new(u, v, w, c0)   # camera_coordinate_system
        
        movements = get_movements() 
      end
      
      def generate_trajectory()
      

      
    end # end class

  end
end