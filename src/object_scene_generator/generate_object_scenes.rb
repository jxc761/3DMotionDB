


module NPLAB
  module ObjectSceneGenerator
    cdn = "/Users/Jing/OneDrive/generated_data/20140626/inputs/components"
  
    ofns = Dir.glob("/Users/Jing/OneDrive/generated_data/20140626/buffer/*.skp")
    cfns = Dir.glob("#{cdn}/*.skp")
    nc = cfns.size
    nObjects = 10
    nScenes  = ofns.size
    srand(Time.now.to_i)
    smps = []
    while smps.size < nScenes
        smp = []
        while smp.size < nObjects
            smp << rand(nc)
            smp.uniq!
        end
        smps << smp.sort
        smps.uniq!
    end
    
  (0...nScenes).each{ |sId| 
    smp = smps[sId] 
    cur_cfns = []
    smp.each{|i| cur_cfns << cfns[i]}
    opts={}
    opts["components_files"]= cur_cfns
    opts["output_filename"] = ofns[sId]
    
    NPLAB.generate_scene(opts)
  }
  end
end