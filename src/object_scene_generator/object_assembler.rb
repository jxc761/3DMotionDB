#load("/Users/Jing/Desktop/combine_objects.rb")
require "#{File.dirname(__FILE__)}/layout.rb"

module NPLAB
 
    class CObjectAssembler
      NPLAB_TABLE_FACE_CN = "nplab_table_face"  # CN: component name
      NPLAB_OBJECTS_GN    = "nplab_objects"     # GN:group name
      def self.sort_componets(comps)
        nc = comps.size
        radii = Array.new(nc)
  
        (0...nc).each{ |i|
          bbox = comps[i].bounds
          w = bbox.width
          d = bbox.depth
          radii[i] = Math.sqrt(d * d + w * w) / 2
        }
  
        compIdx = (0...nc).to_a.sort_by{|i| radii[i]}
  
        newRadii = Array.new(nc)
        newComps = Array.new(nc)
        (0...nc).each{|i|
          newRadii[i] = radii[compIdx[i]]
          newComps[i] = comps[compIdx[i]]
        }
        return [newRadii, newComps]
      end

      def self.combine_objects(face, compdefs, entities)
        # sort components by their base bounding circles
        ret = sort_componets(compdefs)
        radii = ret[0]
        compdefs = ret[1]
  
        centers = CRandomLayout.place(face, radii)
  
        if centers == nil
          puts "Sorry!You can give up or try again"
          return false
        end
  
        (0...compdefs.size).each{ |i|
          transf1 = Geom::Transformation.new(centers[i], face.normal)
          angle   = rand() * 2 * Math::PI
          transf2 = Geom::Transformation.rotation(centers[i], face.normal, angle)
          transf  = transf2 * transf1
          entities.add_instance(compdefs[i], transf)
        } 
        return true
      end
  
      def self.open_studio_and_get_table_face(filename)
  
        status = Sketchup.open_file(filename)
        if not status
          raise "cannot open file: #{filename}"
        end 
  
        model = Sketchup.active_model
        face_def = model.definitions[NPLAB_TABLE_FACE_CN]
        if face_def == nil
          raise "It is not a valid studio scene file because we cannot find the definition of #{NPLAB_TABLE_FACE_CN}"
        end
  
        faces = face_def.instances
        if faces.size != 1
          raise "It is not a valid studio scene file"
        end
        face = nil
        face_def.entities.each{|e|
          if e.typename == "Face"
            face = e
          end
        }
        return [face, faces[0].transformation]
      end

      def self.generate_scene(opts)
        comp_fns  = opts["components_files"]
        filename  = opts["output_filename"]
  
        ret = open_studio_and_get_table_face(filename)
        face = ret[0]
        transf = ret[1]
  
        definitions = Sketchup.active_model.definitions
        comps = []
        comp_fns.each{|comp_fn|
          puts comp_fn
          comps << definitions.load(comp_fn)
        }
  
        group = Sketchup.active_model.entities.add_group
        group.name= NPLAB_OBJECTS_GN
        combine_objects(face, comps, group.entities)
        group.transformation=transf
        Sketchup.active_model.save(filename)
        img = Sketchup.active_model.path.sub(/.skp/,".jpg")
        Sketchup.active_model.active_view.write_image(img, 512, 512, true, 1.0)
      end

      def self.test_generate_scene()
        opts = {}
        cdn = "/Users/Jing/OneDrive/generated_data/20140626/inputs/components"
        cfns = ["#{cdn}/QTips.skp", "#{cdn}/StarbucksGrande.skp", "#{cdn}/CokeCan.skp", "#{cdn}/butterfly.skp"]

        opts["components_files"]= cfns
        opts["output_filename"] = "/Users/Jing/OneDrive/generated_data/20140626/buffer/test01.skp"
        generate_scene(opts)
      end
      
    end # end class
    
    
    
    

end
