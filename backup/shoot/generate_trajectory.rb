module NPLAB
  module Movement
           
    
    def generate_one_pair_trajectories(mver, director, speedor, camera_loction, camera_up, target_location, duration, sl)
      
      
      coordinate_system = build_uvw(camera_loction, camera_up, target_location)
      directions = director.generate_directions(coordinate_system)
      directions.each{ |direction|
        speeds = speedor.generate_speeds()
        speeds.each{|speed|
          reset_mover(mver, camera_location, camera_up, target_location, direction, speed)
          trajecotry = get_one_trajectory(mv, target, duration, sl)
          }
      }
      
    end
   
   def generate_trajectories(mvers, directors, speedors, camera_loction, camera_up, target_location, duration, sl)
     mvers.each{|mver|
       directors.each{|director|
         speedor.each{|speedor|
           generate_one_pair_trajectories(mver, director, speedor, camera_loction, camera_up, target_location, duration, sl)
         }
       }
     }
   end
    
   def generate_trajectries(generate_conf, annotations_files)


  end
end