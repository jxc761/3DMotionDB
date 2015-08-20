module NPLAB

  module CoreIO

    def self.set_spotted_objects(model, objects)
      spots = CoreIO::CSpots.from_instances(objects)  
      model.set_attribute("nplab", "spots", spots.to_s)
    end
    
    def self.get_spotted_objects(model)
      objects = []
      
      s = model.get_attribute("nplab", "spots", "")
      spots = CSpots.from_s(s)
      
      names = spots.get_names.uniq
  
      names.each{|name|
        definition = model.definitions[name]
        if definition == nil
          UI.messagebox("Cannot find component #{name}")
          next
        end
        objects.concat(definition.instances)
      }

      return objects
    end
      
    def self.get_preset_cameras(model)
      
      definition = model.definitions["nplab_camera"]
      
      if definition == nil
        UI.messagebox("no camera")
        return []
      end
      
      
      cameras = definition.instances.collect{|inst|
        
        id      = inst.get_attribute("nplab", "id", Time.now.to_i.to_s)
        transf  = NPLAB::Utils.to_camera_centered_transformation(inst.transformation)
        NPLAB::CoreIO::CCamera.new(id, transf)

      }
      
      return cameras
    end

    def self.load_preset_cameras(filename)
        json = NPLAB::BasicJson.load(filename)
        cameras = json.collect{ |camera| CCamera.from_json(camera)}
        return cameras
    end
    
  end
end