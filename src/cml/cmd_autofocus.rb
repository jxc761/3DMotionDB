require "#{File.dirname(__FILE)}/utils.rb"
module NPLAB
  
  
  module ObjectScene

    def self.autofocus(fn_skp, fn_spots, fn_output, numb)
      new_su = Sketchup.open_file(fn_skp)
      model = new_su.active_model
      
      # get spots information
      if fn_spots == nil
        spots = CSpots.from_model_attr(model)
      else
        spots = CSpots.from_json(fn_spots)
      end
      
      target_objects = find_target_objects(model, spots)
      
      # find cameras in model
      cameras = find_cameras(model)
      
      
      pairs = []
      targets = []
      cameras.each{ |camera|
        cur_ts = autofocus_on_objects(model, camera["position"].origin, target_objects, numb)
        cur_ts.each{ |target|
          pairs << {"camera_id" => camera["id"], "target_id" => target["id"]} 
        }
        targets.concat(cur_ts)
      }
      
      setting = CCameraTargetSetting.new
      setting.cameras = cameras
      setting.pairs = pairs
      setting.targets = targets
      setting.save(fn_output)
      
    end


    def find_cameras(model)
      #  find cameras in model
      definition = model.definitions[NPLAB::CN_CAMERA]
      if definition == nil
        puts "there is no camera"
        return []
      end
      
      instances = definition.instances
      if instances.size == 0
        puts "there is no cameras"
      end
      
      cameras = []
      instances.each{ |inst|
        id = inst.get_attribute(NPLAB::DICT_NAME, NPLAB::AN_ID, Time.now.to_i.to_s)
        position = to_camera_centered_transformation(inst.transformation)
        cameras << {"id" => id, "position" => position}
      }
      return cameras
    end
    
    def find_target_objects(model, spots)
      target_objects = []
      (0...spots.count).each{ |i|
        spot = spots.get_spot(i)
        def_name =  spot["definition"]
    
        definition = model.definitions[def_name]
        if definition == nil
          puts "cannot find the definition"
          next
        end
        
        instances = definition.instances
        target_objects.concat(instances)
      }
      
      return target_objects
      
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