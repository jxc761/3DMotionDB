#!/usr/bin/env ruby

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "Usage:"
  puts "  ./#{cmd_name} <input_dir> <output_dir> <buffer_dir>"
end


def pre_processing(input_dir, output_dir, buffer_dir)
  %x("rm -r #{buffer_dir}")
  %x("rm -r #{output_dir}")

  %x("mkdir #{output_dir}")
  %x("cp -r \"#{input_dir}\" \"#{buffer_dir}\"")

end

# parase commandline arguments
if ARGV.size != 3
  print_usage()
  exit
end

input_dir   = File.absolute_path(ARGV[0])
output_dir  = File.absolute_path(ARGV[1])
buffer_dir  = File.absolute_path(ARGV[2])


puts input_dir
puts output_dir
puts buffer_dir

# pre- processing
pre_processing(input_dir, output_dir, buffer_dir)

puts "after pre-processing"
# processing
app_name  = '"' + '/Applications/SketchUp 2013/SketchUp.app' + '"'
ruby_file = '"' + "#{File.absolute_path(File.dirname(__FILE__))}/text2json.rb" + '"'
cmd       = "open --wait-apps " + app_name + " --args -RubyStartup " + ruby_file



skp_file_list = Dir["#{buffer_dir}/*.skp"]
skp_file_list.each{ |fn_skp|
  puts cmd
  model_name  = File.basename(fn_skp).sub(".skp", "")
  fn_text     = File.join(buffer_dir, "#{model_name}_1.txt")
  fn_json     = File.join(output_dir, "#{model_name}.cts.json")
  
  file =  File.open("#{File.dirname(__FILE__)}/parameters.txt", "w")
  file.puts fn_skp
  file.puts fn_text
  file.puts fn_json
  file.close
  
  system(cmd)
}

# post processing
system("rm #{File.dirname(__FILE__)}/parameters.txt")






