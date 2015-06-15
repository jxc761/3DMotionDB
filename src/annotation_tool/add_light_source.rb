

module NPLAB

	@@add_light_source_tool_config={ "active_component_path" => "#{File.dirname(__FILE__)}/skps/default_light_comp.skp" }


	def get_transf(x, y, view)
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
	

	def self.light_source_comp_path
		return @@add_light_source_tool_config["active_component_path"]
	end
	def self.light_source_comp_path=(new_path)
		@@add_light_source_tool_config["active_component_path"] = new_path
	end


	def self.get_light_source_definition
		cur_path = NPLAB.light_source_comp_path
		Sketchup.active_model.definitions.each{ |definition|

			if definition.path.eql?(cur_path)
				return definition
			end
		}
		defintion = Sketchup.active_model.definitions.load(cur_path)
	end


	class CAddLightTool

		def onLButtonUp(flags, x, y, view)
  			inputpoint = view.inputpoint x,y
			 # the target must be on a face 

			#if inputpoint.face == nil # && inputpoint.edge == nil && inputpoint.vertex == nil
			# 	return nil
			#end
			transformation = NPLAB.get_transf(x, y, view)
			defintion = NPLAB.get_light_source_definition()
			Sketchup.active_model.entities.add_instance(defintion, transformation)

		end

	end
	



  	dn_icons = "#{File.dirname(__FILE__)}/icons"
	cmd_add_light=UI::Command.new("Add a light source"){
		Sketchup.active_model.select_tool( CAddLightTool.new )
	}
	cmd_add_light.large_icon="#{dn_icons}/add_light_24.png"
	cmd_add_light.small_icon="#{dn_icons}add_light_16.png"



	cmd_add_light_config = UI::Command.new("Select light source") {

		 # UI.openpanel("Open SKP File", "c:/", "model.skp")
		input = UI.inputbox(["Path to light source component"], [NPLAB.light_source_comp_path], [""], "Configuration")
		if input
			NPLAB.light_source_comp_path=input[0]
		end 
	}
	cmd_add_light_config.large_icon="#{dn_icons}/config_24.png"
	cmd_add_light_config.large_icon="#{dn_icons}/config_16.png"

	add_light_source_toolbar = UI::Toolbar.new("Add Light Source")
	add_light_source_toolbar.add_item(cmd_add_light)
	add_light_source_toolbar.add_item(cmd_add_light_config)
	
end


file_loaded( __FILE__ )

