
def get_mts(pairs, fps)
	
	mts1 = NPLAB.generate_walking_mts(pairs, fps)
	mts2 = NPLAB.generate_small_mts(pairs, fps)
	
	if mts1.size != pairs.size || mts2.size != pairs.size
		puts bugs
	end

	mts = Array.new(pairs.size)
	(0...mts.size).each do |i|
		mts[i] = mts1[i] + mts2[i]
		#mts[i] = [mts1[i][0]]
	end
	return mts

end

def save_export_options(filename, export_opts)

	txt = ""
	attr_names = ["seed", "width", "height", "fov", "duration", "fps"]
	attr_names.each{ |name|
		txt << name << ":" << export_opts[name].to_s << "\r\n"
	}

    file=File.open(filename, "w")
    file.write(txt)
    file.close()
end



file = File.open("#{File.expand_path(File.dirname(__FILE__))}/parameters.txt", "r")
fn_skp 			= file.readline().strip!
fn_setting		= file.readline().strip!
fn_output_dir 	= file.readline().strip!
fn_opts			= file.readline().strip!
file.close()


Sketchup.open_file(fn_skp)
model=Sketchup.active_model

NPLAB.load_from_txt(model, fn_setting)
		
# seeding
seed =Time.now.to_i
srand(seed)
		
pairs = NPLAB.get_pairs(model)
mts   = get_mts(pairs, 120)

export_opts 			= {}
export_opts["seed"] 	= seed
export_opts["width"] 	= 256
export_opts["height"]  	= 256
export_opts["fov"] 		= 35
export_opts["fps"] 		= 120
export_opts["duration"] = 1.0
export_opts["pairs"] 	= pairs
export_opts["mts"]		= mts

export_opts["path_to_save_to"] = fn_output_dir
save_export_options(fn_opts, export_opts)


Sketchup.active_model.active_view.animation = FixationAnimation.new(export_opts)

#Sketchup.quit
#parameters = "#{File.expand_path(File.dirname(__FILE__))}/parameters.txt"
#UI.messagebox(parameters, MB_YESNO)
#puts "#{File.expand_path(File.dirname(__FILE__))}/parameters.txt"
#puts fn_skp
#puts fn_setting
#puts fn_output_dir
#puts fn_opts


		

