module NPLAB
  module CoreIO 
    
    class CPair < NPLAB::BasicJson::CJsonObject
      attr_accessor :camera_id, :target_id
      
      def initialize(cid, tid)
        @camera_id = cid
        @target_id = tid
      end
      
      def self.from_json(json)
        @camera_id = json["camera_id"]
        @target_id = json["target_id"]
      end
      
      def to_json()
        return {"camera_id"=> @camera_id, "target_id"=> @target_id}
      end
      
    end
    
    
  end
end