module NPLAB
  module CoreIO
    
     CN_PLANE    = "nplab_table_face"    # CN: component name
     
     def get_plane_info(model)
    
       plane_def = model.definitions[CN_PLANE]
       if plane_def == nil
         raise "It is not a valid studio scene file because of no definition of #{CN_PLANE}"
       end
    
       planes = plane_def.instances
       if planes.size != 1
         raise "It is not a valid studio scene file"
       end
    
    
       plane_def.entities.each{|e|
         if e.typename == "Face"
           face = e
           break
         end
       }
    
       hash = { 
         "plane_transf" => planes[0].transformation
         "plane_face" => face
       }
    
       return hash
     end
     
  end
end