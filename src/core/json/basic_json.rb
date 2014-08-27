


module NPLAB
  module BasicJson
    
    class CJsonObject 
    
      def self.from_json(json)
        raise "this is an interface"
      end
    
      def to_json()
        raise "this is an interface"
      end
    
      def self.load(filename)
        json = BasicJson.load(filename)
        return self.from_json(json)
      end
    
      def save(filename)
        json = to_json()
        BasicJson.save(json, filename)
      end
    
      def to_s()
        json = to_json()
        jstr = BasicJson.to_json(json)    
        return jstr
      end
    
      def self.from_s(jstr)
        json = BasicJson.from_json(jstr)
        return self.from_json(json)
      end
      
    end
    
    
  end
end