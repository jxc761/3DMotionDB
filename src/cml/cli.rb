module NPLAB
  
  

  
  class C
    def self.save_args(args)
      raise "This is an interface"
    end
    
    def self.load_args()
    end
    
    def self.run(args)
      
      
      app_name  = '"' + '/Applications/SketchUp 2013/SketchUp.app' + '"'
      ruby_file = '"' + "#{File.absolute_path(File.dirname(__FILE__))}/text2json.rb" + '"'
      cmd       = "open --wait-apps " + app_name + " --args -RubyStartup " + ruby_file
      
      save_args(args)
      system(cmd)
    end
    
    
  end
end