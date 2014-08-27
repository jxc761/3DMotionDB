module NPLAB

  module CoreIO
    
    def self.set_spots(model, spots)
      model.set_attribute("nplab", "spots", spots.to_s)
    end
    
    def self.get_spots(model)
      s = model.get_attribute("nplab", "spots", "")
      return CSpots.from_s(s)
    end
      
    def self.get_cameras(model)
      
    end
    
  end
end