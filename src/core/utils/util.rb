module NPLAB
  module Utils
    
    
    def self.hide_annotation()
      model = Sketchup.active_model
      
      layer = model.layers["nplab_cameras"]
      if layer 
        layer.visible = false
      end
      
      layer = model.layers["nplab_targets"]
      if layer
        layer.visible = false
      end
      
    end
    
  end
end