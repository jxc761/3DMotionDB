require "#{File.dirname(__FILE)}/utils.rb"
module NPLAB
  module ObjectSceneGenerator
    # Geom::Point3d camera_position 

    
    # core algorithm for auto_focus
    def self.pick_focus_on_object(camera_position, target_object, model, numb)
      focus  = []
      bbox = targt_object.bounds
      
      points  = (0...7).collect { |i| bbox.corner(i) } 
      while focus.size < numb
      
        candidate  = rand_pick(points)
        direction  = camera_position - candidate
        ray        = [camera_position, direction]
        item       = model.raytest(ray)
        if item && bbox.contains?(item[0])
          focus << item[0]
        end
        
      end
      
      return focus 
    end
    
    
    
  end
end