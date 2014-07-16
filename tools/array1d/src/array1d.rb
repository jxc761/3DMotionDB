
module NPLAB
  
  module Array1D
    def self.normalize(v)
      z = length(v)
      n = v.size
      nv = Array.new(n){0.0}
      (0...n).each{|i| nv[i]=v[i] * 1.0 / z}
      return nv
    end
          
    def self.normalize!(v)
      z = length(v)
      v.each_index{|i| v[i] = v[i]/z}
      return v
    end
    
    def self.norm2(v)
      n2 = 0.0
      v.each{|vi| n2 = n2 + vi * vi}
      return n2
    end
    
    def self.length(v)
      return Math.sqrt(norm2(v))
    end

    def self.linear_combination(ws, vs)
      m = ws.size
      n = vs[0].size
      
      result = Array.new(n){0.0}
      (0...m).each{ |i|
        (0...n).each{|j|
          result[j] += ws[i] * vs[i][j]
        }
      }
      return result
    end
    
    def self.add(v1, v2)
      n = v1.size
      v = Array.new(n){0.0}
      (0...n).each{|i|
        v[i] = v1[i] + v2[i]
      }
      return v
    end
    
    def self.scale(s, v)
      n = v.size
      rv = Array.new(n){0.0}
      (0...n).each{ |i|
        rv[i] = v[i] * s * 1.0
      }
      return rv
    end
    
    def self.scale!(s, v)
      v.each_index{|i|
        v[i] = v[i] * s * 1.0
      }
      return v
    end
    
    def self.dot(v1, v2)
      result = 0.0
      n = v1.size
      (0...n).each{|i| result += v1[i] * v2[i]}
      return result
    end
    
  end
end
