

module NPLAB
  
  def self.instance_from_camera_target_setting(model, setting)
    
  end
  
  def self.instance_to_camera_target_setting(model, setting)
  
  end
  
  class CCameraTargetSetting < CJsonObject
    attr_accessor :cameras, :targets, :pairs
    
    def initialize()
      @cameras = []
      @targets = []
      @pairs   = []
    end

    
    alias to_json to_hash
    alias from_json from_hash
    
    def to_hash()
      hash = {"cameras" => cameras, "targets" => targets, "pairs" => pair }
    end
    
    def self.from_hash(h)
      o = self.new
      o.cameras = h["cameras"]
      o.targets = h["targets"]
      o.pairs   = h["pairs"]
      return o
    end
    
  end

end