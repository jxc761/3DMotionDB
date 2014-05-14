
require "#{File.dirname(__FILE__)}/annotation.rb"
#load('/Users/Jing/Library/Application Support/SketchUp 2013/SketchUp/Plugins/annotation/ui_save_setting.rb')
module NPLAB_UI
	#----------------------------------------------------------------
	#
	#----------------------------------------------------------------
	def self.ui_save_setting_as()
		model = Sketchup.active_model
		directory = File.dirname(model.path)
		basename = File.basename(model.path, ".skp" ) 
		filename = UI.savepanel("Save Model", directory, basename + ".txt")
		if filename == nil
			return 
		end
		save_setting(model, filename)
		Sketchup.set_status_text "The setting have been saved to #{filename}"
	end

	def self.ui_save_setting()
		model = Sketchup.active_model
		while model.path == ""
			path_to_save_to = UI.savepanel("Save Model", "./", "model.skp")
			if path_to_save_to == nil
				Sketchup.set_status_text "The setting can not be saved before the model is saved"
				return 
			end
		end	
	
		filename = gen_file_name(model, ext="txt")
		save_setting(model, filename)
		Sketchup.set_status_text "The setting have been saved to #{filename}"
	end


	def self.save_setting(model, filename)
		# build the pair
		model = Sketchup.active_model
		camera_def = NPLAB.get_definition(model, NPLAB::CN_CAMERA, NPLAB::FN_CAMERA)
		cameras = camera_def.instances
		target_def = NPLAB.get_definition(model, NPLAB::CN_TARGET, NPLAB::FN_TARGET)
		targets = target_def.instances
	
		pairs = []
		cameras.each{|camera|
			targets.each{|target|
				pairs << [camera, target]
			}
		}
		
		NPLAB.set_pairs(model, pairs)
	    NPLAB.save_to_txt(model, filename)
	end

	#
	def self.gen_file_name(model, ext="txt")
		prefix = model.path.sub(/.skp/,"")
		i = 1
		while true
			filename = prefix + "_" + i.to_s + "." + "txt"
			if !File.file?(filename)
				break
			end
			i += 1
		end
		return filename
	end
end