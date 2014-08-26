module NPLAB
  
  class CRenderSetting < CJsonObject

    alias to_json to_hash
    alias from_json from_hash
  
    def to_hash()
      h = {}
      instance_variables.each{|v|
        name  = v.sub(/^@/,"")
        value = instance_variable_get(v)
        h[name] = value
      }
      return h
    end
    
    def self.from_hash(h)
      o = self.new
      h.each_pair{ |key, value|
        instance_variable_set(key, value)
      }
      return o
    end
    
  end
  
  class CSURenderSetting < CJsonObject
    # camera related parameters
    # px, px, mm, degree
    #
    attr_accessor :image_height, :image_width, :film_width, :fov
    
    def aspect_ratio 
      @image_width * 1.0 / @image_height
    end
    
  end

end
