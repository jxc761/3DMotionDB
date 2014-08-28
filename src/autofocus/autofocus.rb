
require "#{File.dirname(File.dirname(__FILE__))}/core.rb"
module NPLAB
    
  module Autofocus

    #
    # require the scene contain the information about the camera information & spots information
    #
    def self.autofocus(fn_skp, numb)
      # open file
      status = Sketchup.open_file(fn_skp)
      unless status
        raise "Cannot open file: #{fn_skp}"
      end
      model = new_su.active_model
      
      # autofocus
      cts = autofocus_in_model(model, numb)
      
      # saveout
      cts.save(fn_skp)
    end
    
    
    def self.autofocus_in_model(model, numb)
      objects   = CoreIO.get_spotted_objects(model) # Array<ComponentInstance>
      cameras   = CoreIO.get_preset_cameras(model)
      
      cameras.each{ |camera|
        camera_location = camera.position.origin
        targets = autofocus_on_objects(model, camera_location, objects, numb)
        pairs << build_pair(camera, targets)
        
      }
      
    end
    
    def self.autofocus_on_each_object(model, camera_location, objects, numb)
      targets = []
      objects.each{|target_object|
        t = autofocus_on_object(model, camera_location, target_object, numb)
        targets.concat(t)
      }
      return targets
    end
    
    
    def self.autofocus_on_objects(model, camera_location, objects, numb)
      
      targets = []
      
      picked_objects = Array.new(numb){objects[rand(objects.size)]}
      
      picked_objects.each{ |target_object|
        t = autofocus_on_object(model, camera_location, target_object, 1)
        targets.concat(t)
      }  
      return targets
    end
    
  
    # core algorithm for auto_focus
    def self.autofocus_on_object(model, camera_location, target_object, numb)
      targets  = []
      
      bbox = targt_object.bounds
      points  = (0...7).collect { |i| bbox.corner(i) } 
      while targets.size < numb
      
        candidate  = Utils.rand_pick(points)
        direction  = camera_location - candidate
        ray        = [camera_location, direction]

        location, face, transf = raytest(model, ray, target_object)
        
        next unless location
        
         
        zaxis    = face.normal.transformation(transf)
        id       = Time.now.to_i.to_s
        position = Geom::Transformation.new(location, zaxis)
        
        target = CTarget.new(id, position)
        targets << target
        
      end
       
      return targets 
      
    end
    
    # Return
    # if hit the target on face, it will return 
    #   [Point3d, face, transfromation]
    # else nil
    def self.raytest(model, ray, target)
      hit = model.raytest(model, ray)
      return nil unless hit
    
    
      # hit position
      position = hit[0]
    
    
      hit_path = hit[1]
    
      # hit a face
      if hit_path[-1].typename != "Face"
        return nil
      end
      face = hit_path[-1]
    
      # test whether it hits the target 
      ishit = false
      hit_path.each{ |inst|
        ishit |= (inst==target)
      }
      return nil unless ishit
    
      # the transformation
      transf = Geom::Transformation.new
      (0...hit_path.length-1).each{ |inst|  
        transf = transf * inst.transformation
      }
    
      return [position, face, transf]      
    
    end
    
  end
end


=begin
    def self.pick_focus_on_objects_with_pr(camera_position, target_objects, model, numb)
      volumes = target_objects.collect{|obj|
        bbox=obj.bounds
        w=bbox.width
        h=bbox.height
        d=bbox.depth
        w*h*d
      }
      cum_volumes = volumes
      
    end
    
    def self.autofocus_on_objects_even(camera, targets, model, numbPerObject)
    end
    
    def self.autofocus_on_every_objects(camera, target, model, number)
    
=end