
require "#{File.dirname(File.dirname(__FILE__))}/core.rb"
module NPLAB
    
  module Autofocus

    #
    # require the scene contain the information about the camera information & spots information
    #
    def self.autofocus(fn_skp, fn_setting, numb)
      # open file
      status = Sketchup.open_file(fn_skp)
      unless status
        raise "Cannot open file: #{fn_skp}"
      end
      model = Sketchup.active_model
      
      # autofocus
      setting = autofocus_in_model(model, numb)
      
      # saveout
      setting.save(fn_setting)
      
      model.save(model.path)

    end
    

    def self.autofocus_in_model(model, numb)
 
      objects   = CoreIO.get_spotted_objects(model) # Array<ComponentInstance>
      cameras   = CoreIO.get_preset_cameras(model)
       
      targets   = []
      pairs     = []
      
      cameras.each{ |camera|
        camera_location = camera.position.origin
        ts  = autofocus_on_objects(model, camera_location, objects, numb, 0 )
        ps  = ts.collect{ |t| NPLAB::CoreIO::CPair.new(camera.id, t.id) }
        targets.concat(ts)
        pairs.concat(ps)
      }
      return NPLAB::CoreIO::CCameraTargetSetting.new(cameras, targets, pairs)
      
    end
    
    def self.autofocus_in_model_with_cameras(model, camera, numb)
      

      objects   = CoreIO.get_spotted_objects(model) # Array<ComponentInstance>
     
      targets   = []
      pairs     = []

      camera_location = camera.position.origin
      targets  = autofocus_on_objects(model, camera_location, objects, numb, 0 )
      pairs = targets.collect{ |t| NPLAB::CoreIO::CPair.new(camera.id, t.id) }
      cameras = [camera]

      return NPLAB::CoreIO::CCameraTargetSetting.new(cameras, targets, pairs)
    end

    def self.autofocus_on_each_object(model, camera_location, objects, numb, begin_id=Time.now.to_i)
      targets = []
      objects.each{|target_object|
        t = autofocus_on_object(model, camera_location, target_object, numb, begin_id)
        begin_id += numb
        targets.concat(t)
      }
      return targets
    end
    
    
    def self.autofocus_on_objects(model, camera_location, objects, numb, begin_id=Time.now.to_i)

      targets = []
      
      picked_objects = Array.new(numb){objects[rand(objects.size)]}
      
      picked_objects.each{ |target_object|
        t = autofocus_on_object(model, camera_location, target_object, 1, begin_id)
        begin_id += 1
        targets.concat(t)
      }  
 
      return targets
    end
    
  
    # core algorithm for auto_focus
    def self.autofocus_on_object(model, camera_location, target_object, numb, begin_id=Time.now.to_i)

      bbox = target_object.bounds
      points  = (0...8).collect{ |i| bbox.corner(i) } 
      targets  = []
      while targets.size < numb
        puts "finding focus ....."
        
        candidate  = Utils.rand_pick(points)
        direction  = candidate - camera_location 
        ray        = [camera_location, direction]
        
        location, face, transf = raytest(model, ray, target_object)
        next unless location
      
        id       = (begin_id + targets.size).to_s
        zaxis    = face.normal.transform(transf)
        position = Geom::Transformation.new(location, zaxis)
      
        target = NPLAB::CoreIO::CTarget.new(id, position)
        targets << target
        
      end

      return targets 
      
    end
    
     
    
    # Return
    # if hit the target on face, it will return 
    #   [Point3d, face, transfromation]
    # else nil
    def self.raytest(model, ray, target)
      
      hit = model.raytest(ray)
      return nil unless hit
    
      # hit position
      position = hit[0]
      hit_path = hit[1]
      

      
      if hit_path[-1].typename != "Face"
        #UI.messagebox("does not hit a face")
        return nil
      end
      
      # hit a face
      face = hit_path[-1]
          
      # no occulde
      ishit = target.bounds.contains?(position)
      return nil unless ishit  

      # the transformation
      transf = Geom::Transformation.new
      hit_path[0...-1].each{ |inst|
        transf = transf * inst.transformation
      }
      
      return [position, face, transf]      
    
    end
    
  end
end


=begin
    def self.draw_box(position)
      
      o  = position.origin.clone
      vx = position.xaxis.clone
      vy = position.yaxis.clone
      vz = position.zaxis.clone
      
      vx.length=2.5.cm
      vy.length=2.5.cm
      vz.length=2.5.cm
      
      p1 = o - vz + vx + vy
      p2 = o - vz - vx + vy
      p3 = o - vz - vx - vy
      p4 = o - vz + vx - vy
      
      
      group = Sketchup.active_model.entities.add_group
      face = group.entities.add_face([p1, p2, p3, p4])
      face.material="blue"
      face.pushpull(5.cm)
      
    end
    
    def self.draw_bbox(bbox)
      group = Sketchup.active_model.entities.add_group
      
      pts = (0...8).collect{ |i| bbox.corner(i) }
     
      color=Sketchup::Color.new(255, 0, 0)
      color.alpha=0.2
      face = group.entities.add_face([pts[0], pts[1], pts[3], pts[2]])
      face.material=color
      edge = group.entities.add_edges([pts[0], pts[4]])
      face.followme(edge)
      
      #group.entities.add_edges([pts[4], pts[5], pts[7], pts[6], pts[4]])
      #group.entities.add_edges([pts[1], pts[5]])
      #group.entities.add_edges([pts[2], pts[6]])
      #group.entities.add_edges([pts[3], pts[7]])
    end
 
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