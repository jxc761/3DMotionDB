module NPLAB
  
  
	#--------------------------------------------------------
  # Assistance functions
  #--------------------------------------------------------
	def self.get_transf(x, y, view)
		inputpoint = view.inputpoint x,y
		
		origin = inputpoint.position
		
    # if inputpoint.vertex 
		#	 origin = inputpoint.vertex.position
		#	 origin.transform! t
		# end
		
		normal = Geom::Vector3d.new [0, 0, 1]
		if inputpoint.face != nil 
			 normal = inputpoint.face.normal
       transf = inputpoint.transformation
			 normal.transform! transf
		end
				
		transformation = Geom::Transformation.new(origin, normal)	
		return transformation
	end
	
  
  
	def self.get_camera_number()
		model = Sketchup.active_model
		definition = model.definitions[NPLAB::CN_CAMERA] 
		
		if definition != nil 
			return definition.instances.size
		end
		
		return 0
	end
  
	def self.get_target_number()
		model = Sketchup.active_model
		definition = model.definitions[NPLAB::CN_TARGET] 
		
		if definition != nil 
			return definition.instances.size
		end
		
		return 0
	end
end
