module NPLAB
  module CoreIO
    
     CN_PLANE    = "nplab_table_face"    # CN: component name
     
     def self.get_table_plane(model)
       msg = "It is not a valid studio file"
       plane_def = model.definitions[CN_PLANE]
      
       if plane_def == nil
         UI.messagebox(msg)
         raise msg
       end
   
       planes = plane_def.instances
       if planes.size != 1
         UI.messagebox(msg)
         raise msg
       end

       face = nil
       plane_def.entities.each{|e|
         if e.typename == "Face"
           face = e
           break
         end
       }
       
       if face == nil
         UI.messagebox(msg)
         raise msg
       end
       
       return [face, planes[0].transformation]
     end
     
  end
end