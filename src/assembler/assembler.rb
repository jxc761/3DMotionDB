require "#{File.dirname(__FILE__)}/layout.rb"

module NPLAB
  module Assembler
    
    GN_OBJECTS  = "nplab_objects_group"       # GN: group name
    LN_OBJECTS  = "nplab_objects_layer"       # LN: layer name
    
    def self.assemble(fn_studio, dn_objects, fn_output_skp, nobjects)

      # new model with fn_studio
      %x("cp \"#{fn_studio}\" \#{fn_output_skp}"\"")
      new_su = Sketchup.open_file(fn_output_skp)
      model = new_su.active_model

      # assmeble objects
      objects = assemble_in_model(model, dn_objects, nobjects)

      # set these objects as the spots
      spots = CSpots.from_objects(objects)
      CoreIO.set_spots(model, spots)
            
      # save the model      
      Sketchup.active_model.save(fn_output_skp)
      
    end

    def self.assemble_in_model(model, dn_objects, nobjects)
      fn_objects = Dir[File.join(dn_objects, "*.skp")]
      
      # prepare plane
      plane = CoreIO.get_table_plane(model)
      
    
      # load in the definitions of objects
      definitions = fn_objects.collect{ |fn_object|  model.definitions.load(fn_objects)}
 
      # find feasible combination
      centers = find_fesible_layout(definitions, plane, nobjects)
      
      # assemble objects
      assemble_objects(model, definitions, centers, plane.normal)
      
      # purge unused
      model.definitions.purge_unused

      return objects
      
    end
    
    
    # ------------------------------------
    # Private
    # ------------------------------------
    def get_radii(comps)
      radii = comps.collect{ |comp|
        bbox = comp.bounds
        w = bbox.width
        d = bbox.depth
        Math.sqrt(d * d + w * w) / 2
      }
      return radii
    end
    
    def find_fesible_layout(definitions, plane, nobjects)
      # find feasible combination
      radii = get_radii(definitions)
      
      centers = nil
      while centers == nil
        puts "Finding fesible assemble, please wait....."
        
        # random select objects
        selected = Array.new(nobjects){ radii[rand(definitions.size)]}
        
        # compute their raddis layout
        centers = CRandomLayout.place(plane, selected)
        
      end
      
      return centers
    end
    
    def assemble_objects(model, definitions, centers, normal)
      
      objects  = []
      
      # create group
      group = model.entities.add_group
      group.name= GN_OBJECTS

      # add object one by one
      (0...definitions.size).each{ |i|
        
        # the transformation that put the object at the position
        transf1 = Geom::Transformation.new(centers[i], normal)

        # randomly roation
        angle   = rand() * 2 * Math::PI
        transf2 = Geom::Transformation.rotation(centers[i], normal, angle)
        
        # the final transformation
        transf  = transf2 * transf1
        
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
