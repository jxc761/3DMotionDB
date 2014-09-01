module NPLAB
  module Utils
    
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
   
  end
end