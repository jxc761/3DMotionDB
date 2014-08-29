require "#{File.dirname(File.dirname(__FILE__))}/core.rb"
require "#{File.dirname(__FILE__)}/layout.rb"

module NPLAB
  module Assembler
    
    GN_OBJECTS  = "nplab_objects_group"       # GN: group name
    LN_OBJECTS  = "nplab_objects_layer"       # LN: layer name
    
  
    
    def self.assemble(fn_skp, fn_spots, fn_img, dn_objects, nobjects)
      # new model with fn_output_skp    
      status = Sketchup.open_file(fn_skp)
      unless status
        raise "Cannot open file: #{fn_skp}"
      end
      model = Sketchup.active_model

      # assmeble objects
      objects = assemble_in_model(model, dn_objects, nobjects)
     
      # set these objects as the spots and save the information out
      spots = CoreIO::CSpots.from_instances(objects)   
      spots.save(fn_spots)
  
      
      # save the model      
      model.save(fn_skp)
      model.active_view.write_image(fn_img, 256, 256, true, 1.0)
    end

    def self.assemble_in_model(model, dn_objects, nobjects)
      
      fn_objects = Dir[File.join(dn_objects, "*.skp")]
      
      # prepare plane
      plane, transf = CoreIO.get_table_plane(model)
      
    
      # load in the definitions of objects
      definitions = fn_objects.collect{ |fn_object|  model.definitions.load(fn_object)}
     
      
      # find feasible combination
      selected, centers = find_fesible_layout(definitions, plane, nobjects)
 
      
      # assemble objects
      objects = assemble_objects(model, selected, centers, plane, transf)
     
      # set spots 
      CoreIO.set_spotted_objects(model, objects)
      
      # purge unused
      model.definitions.purge_unused
      
      return objects
      
    end
    
    def self.clear_assemble(model)
    
    end
    
    # ------------------------------------
    # Private
    # ------------------------------------
    def self.get_radii(comps)
      radii = comps.collect{ |comp|
        bbox = comp.bounds
        w = bbox.width
        d = bbox.depth
        Math.sqrt(d * d + w * w) / 2
      }
      return radii
    end
    
    def self.find_fesible_layout(definitions, plane, nobjects)
      # find feasible combination
      radii = get_radii(definitions)
      
      centers = nil
      selected = nil
      
      while centers == nil
        puts "Finding fesible assemble, please wait....."
        
        # random select objects
        selected_idx = Array.new(nobjects){ rand(definitions.size) }
        
         # compute their raddis layout
        selected_r = selected_idx.collect{|i| radii[i]}
        selected = selected_idx.collect{|i| definitions[i]}
        centers = CRandomLayout.place(plane, selected_r)

      end
      
      return [selected, centers]
    end
    
    def self.assemble_objects(model, definitions, centers, plane, transformation)
    
      objects  = []
      
      # create group
      group = model.entities.add_group
      group.name= GN_OBJECTS

      
      # add object one by one
      (0...definitions.size).each{ |i|
     
        # the transformation that put the object at the position
        transf1 = Geom::Transformation.new(centers[i], plane.normal)
        
        # randomly roation
        angle   = rand() * 2 * Math::PI
        transf2 = Geom::Transformation.rotation(centers[i], plane.normal, angle)
      
        # the final transformation
        transf  = transformation * transf2 * transf1
        
        objects << group.entities.add_instance(definitions[i], transf)
  
      } 
     
      # set layer
      layer = model.layers[LN_OBJECTS]
      unless layer
        layer = model.layers.add(LN_OBJECTS) 
      end
      group.layer=layer
      
    
      return objects
    end

  end
end


=begin
    
    def self.assemble_scenes(fn_studio, dn_objects, dn_outputs, nscenes, nobjects)
      status = Sketchup.open_file(fn_studio)
      unless status
        raise "Cannot open file: #{fn_studio}"
      end
      studio_name = File.basename(fn_studio).sub(/\.skp$/, "")
      
      model = Sketchup.active_model
      model.active_view.camera.fov=45
     
      (0...nscenes).each{|s|
        puts "scene: #{s}....."
        fn_output_spots = File.join(dn_outputs, "#{studio_name}_#{s}.json")
        fn_output_skp   = File.join(dn_outputs, "#{studio_name}_#{s}.skp")
        fn_output_img   = File.join(dn_outputs, "#{studio_name}_#{s}.jpg")
        
        objects = assemble_in_model(model, dn_objects, nobjects)
      
        spots = CoreIO::CSpots.from_instances(objects)
        CoreIO.set_spotted_objects(model, spots)
        spots.save(fn_output_spots)
        
        model.save(fn_output_skp)
        model.active_view.write_image(fn_output_img, 256, 256, true, 1.0)
        
        # clear the model
        model.entities.erase_entities(objects[0].parent)
        model.definitions.purge_unused
      }
      
    end
=end