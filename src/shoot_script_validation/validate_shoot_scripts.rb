module NPLAB
  module ShootScriptValidation
    
    def self.validate_scripts(fn_skp, dn_scripts, dn_outputs)
      status = Sketchup.open_file(fn_skp)
      unless status
        raise "Cannot open #{fn_skp}"
      end
      
      scripts = Dir[File.join(dn_scripts, "*.ss.json")]
      
      scripts.each{ |fn_ss|
        shoot_script = NPLAB::CoreIO::CShootScript.load(fn_ss)
        if self.valid?( shoot_script )
          puts "valid: #{fn_ss}"
          dst = File.join(dn_outputs, File.basename(fn_ss))
          system('cp "' + fn_ss + '" "' + dst + '"')
        else
          puts "Not valid: #{fn_ss}"
        end
      }
      
    end
    
    def self.valid?( shoot_script)
      
      model = Sketchup.active_model
      
      NPLAB::Utils.hide_annotation()
      
      # collect all entities in current model
      model_entities = []
      model.entities.each{ |e| model_entities << e}
       
      # build the group based on the camera_tr and target
      group = model.entities.add_group
      
      pt_t  = shoot_script.target.position.origin
      trace = shoot_script.camera_tr.trace
      (1...trace.length).each{|i|
        group.entities.add_face(pt_t, trace[i-1].origin, trace[i].origin)
      }
        
      # intersect the group with model
      intersection = Sketchup.active_model.entities.add_group
      
      recurse = false
      t1 = Geom::Transformation.new
      e1 = intersection.entities
      t2 =  Geom::Transformation.new
      hidden = false
      
      
      group.entities.intersect_with(recurse, t1, e1, t2, hidden, model_entities)
      
      isvalid = (e1.count == 0)
      
      
      # erase the new groups
      model.entities.erase_entities([group, intersection])
      
      return isvalid
    end
    
    
  end
end