module NPLAB
  module Utils
    #def self.to_m(a) 
    #  b = a.collect{|x| x.to_m}
    #  return b
    #end
    
    #def self.from_m(a)
      #b = a.collect{|x| x.m}
      #return b
    #end
    
    
    
    def self.build_uvw_system(v, w)
      v = Geom::Vector3d.new(v)
      w = Geom::Vector3d.new(w).normalize
      u = v.cross(w).normalize
      v = w.cross(u).normalize
      return [u, v, w]
    end
    
    

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
    

    ################
    def self.linear_combination(weights, points)
       result = Geom::Point3d.new(0, 0, 0)
       nK = weights.size
       (0...nK).each{ |i|
         result[0] += weights[i] * points[i][0]
         result[1] += weights[i] * points[i][1]
         result[2] += weights[i] * points[i][2]
       }
       return result
     end

     def self.scale(pt, k)
       pt[0] = pt[0] * k
       pt[1] = pt[1] * k
       pt[2] = pt[2] * k
       return pt
     end

     def self.rand_pick(points)
       n = points.size
       weights = Array.new(n){rand()}

       norm = 0.0
       weights.each{|w| norm += w}

       pt = linear_combination(weights, points)
       pt = scale(pt, 1.0/norm) 
     end

     ####################
  end
  
end