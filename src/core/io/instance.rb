module NPLAB
  module CoreIO
    
    class CInstance < CJsonObject
      attr_accessor: @id, @position
      
      def initilize(id, position)
        @id = id
        @position = position
      end
      
      def to_json()
        return {"id" => @id, "position"=>Utils.transf_to_hash(@position)}
      end
      
      def self.from_json(json)
        id = json["id"]
        position = Utils.hash_to_transf(json["position"])
        return self.new(id, position)
      end
      
      def location
        position.origin
      end
      
      def up
        position.zaxis
      end
      
    end
    
    alias CCamera CInstance
    alias CTarget CInstance
  end
end