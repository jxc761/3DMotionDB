module NPLAB
  module Utils
    

    def self.transf_to_hash(transf)
      if transf == nil
        return nil
      end
      
      hash = {"origin"  => transf.origin.to_a,
        "xaxis"  => transf.xaxis.to_a,
        "yaxis"  => transf.yaxis.to_a,
        "zaxis"  => transf.zaxis.to_a}
      return hash
    end
    
    def self.hash_to_transf(hash)
      if hash == nil
        return nil
      end

      xaxis   = Geom::Vector3d.new(hash["xaxis"])
      yaxis   = Geom::Vector3d.new(hash["yaxis"])
      zaxis   = Geom::Vector3d.new(hash["zaxis"])
      origin  = Geom::Point3d.new(hash["origin"])
      Geom::Transformation.new(xaxis, yaxis, zaxis, origin)
    end
    
    
    #====
    def self.to_camera_centered_transformation(t) 
      offset = t.zaxis.clone
      offset.length= 1.7.m
      new_origin = t.origin + offset
      return Geom::Transformation.new(t.xaxis, t.yaxis, t.zaxis, new_origin)
    end
  
    def self.to_instance_transformation(t)
      offset = t.zaxis.clone
      offset.length= 1.7.m
      new_origin = t.origin - offset
      return Geom::Transformation.new(t.xaxis, t.yaxis, t.zaxis, new_origin)
    end
    
  end
  
end