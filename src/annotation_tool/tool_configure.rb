module NPLAB
  
     
    FN_CAMERA  = "#{File.dirname(__FILE__)}/skp/nplab_camera.skp" #FN: Filenmae
    FN_TARGET  = "#{File.dirname(__FILE__)}/skp/nplab_target.skp"
    FN_EMPTY   = "#{File.dirname(__FILE__)}/skp/nplab_empty.skp"
    CN_CAMERA  = "nplab_camera" #CN: Component name
    CN_TARGET  = "nplab_target"
  
    # layer name 
    LN_CAMERAS  = "nplab_cameras"
    LN_TARGETS  = "nplab_targets"
    
    # dictionary name
    DICT_NAME = "nplab"
    AN_PAIRS = "pairs" # AN:ATTRIBUTE_NAME
    AN_ID = "id" 


    @@tool_config_file = "#{File.dirname(__FILE__)}/js/config.json"
    @@tool_config = BasicJson.load(@@tool_config_file )

    def self.auto_path?
        return @@tool_config["auto_path"]
    end

    def self.path_to_output
        return @@tool_config["path"]
    end


     def self.single_cts?
        return @@tool_config["bsingle"]
    end

    def self.relabel?
        return @@tool_config["brelabel"]
    end

    def self.save_tool_config
        BasicJson.save(@@tool_config_file, @@tool_config)
    end

    def self.set_tool_config(value)
         @@tool_config = BasicJson.parse(value)

    end

    def self.get_tool_config
        json = BasicJson.to_json(@@tool_config)
        return json
    end

end