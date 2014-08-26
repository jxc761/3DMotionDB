require "#{File.dirname(__FILE__)}/basic_json_parser.rb"
require "#{File.dirname(__FILE__)}/basic_json_writer.rb"


module NPLAB
  class CJsonObject 
    def self.from_json()
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
    
  end
end