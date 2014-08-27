module NPLAB
  module CoreIO
    
    class CSpots < CJsonObject
   
      def initialize(spots)  
        @spots = spots
      end

      def self.from_json(json)
        array = BasicJson.form_json(json)
        spots = array.collect{ |a|
          {"name" => a[name], "position" => Utils.hash_to_transf(a["position"])}
        }
        return self.new(spots)
      end
    
      def to_json()
        json = @spots.collect{ |spot|
                  {"name" => spot["name"], "position" => Utils.transf_to_hash(spot["position"])}
                }
        
        return json
      end
    
      def self.from_instances(insts)
        spots = insts.collect{ |obj|
          {"name" => obj.definition.name, "position" => obj.transformation}
        }
        return self.new(spots)
      
      end
            
    end
  end

end