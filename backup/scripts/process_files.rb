input_dir 	= "/Users/Jing/OneDrive/generated_data/20140602/inputs/"
output_dir	= "/Users/Jing/OneDrive/generated_data/20140602/outputs/"
Dir.mkdir(output_dir) unless File.directory?(output_dir)

files = Dir[File.join(input_dir, '*.skp')]
files.each{|skp_filename|
	
	name = File.basename(skp_filename, ".skp")
	setting_filename = File.join(input_dir, "#{name}_1.txt")
	export_filename = File.join(output_dir, "#{name}.txt")
	path_to_save_to = File.join(output_dir, "#{name}")
	
	file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "w")
	file.puts skp_filename
	file.puts setting_filename
	file.puts path_to_save_to
	file.puts export_filename
	file.close()
	
	puts "processing #{skp_filename}. Please waiting"
	app_name = '"' + '/Applications/SketchUp 2013/SketchUp.app' + '"'
	ruby_file = '"' + "#{File.absolute_path(File.dirname(__FILE__))}/process_one_file.rb" '"'
	cmd = "open --wait-apps " + app_name + " --args -RubyStartup " + ruby_file
	system(cmd)
}
	