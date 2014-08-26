module NPLAB

  
  
   class CShootScript < CBasicJson
     attr_accessor  :target, :camera, :camera_tr


     def to_hash()
       h = {  
         "target" : @target,
         "camera" : @camera,
         "camera_tarjectory" : @camera_tr}
       return h
     end
     
     def self.from_hash(h)
       o = self.new()
       o.target = h["target"]
       o.camera = h["camera"]
       o.camera_tr = CTrajectory.from_hash(h["camera_trajectory"])
       return o
     end
     
     def self.target_id
       @target["id"]
     end
     
     def self.target_id=(id)
       @target["id"] = id.to_s
     end
     
     def self.camera_id
       @camera[id]
     end
     
     def self.camera_id=(id)
       @camera["id"] = id.to_s
     end
     
     def target_position
       Utils.hash_to_transf(@target["position"])
     end
     
     def target_position=(pos)
       @target["position"] = Utils.transf_to_hash(pos)
     end
     
     def target_location
       target_position.origin
     end
     
     alias to_json to_hash
     alias from_json from_hash
     

   end
 
   
   

end