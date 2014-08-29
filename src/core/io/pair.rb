module NPLAB
  module CoreIO 
    
    class CPair < NPLAB::BasicJson::CJsonObject
      attr_accessor :camera_id, :target_id
      
      def initialize(cid, tid)
        @camera_id = cid
        @target_id = tid
      end
      
      def self.from_json(json)
        cid = json["camera_id"]
        tid = json["target_id"]
        return self.new(cid, tid)
      end
      
      def to_json()
        return {"camera_id"=> @camera_id, "target_id"=> @target_id}
      end
      
    end
    
    
  end
end