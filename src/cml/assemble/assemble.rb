#!/usr/bin/env ruby

require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "./#{cmd_name} <fn_conf>"
end

if ARGV.size != 1
  print_usage()
  exit
end

required = ["dn_studios", "dn_objects", "dn_outputs", "nscenes", "nobjects"]
args = CLIUtil.get_vars(ARGV[0], required)


fn_ruby = File.join( File.dirname(File.absolute_path(__FILE__)), "su_assemble.rb")

dn_studios  = args["dn_studios"]
dn_objects  = args["dn_objects"]
dn_outputs  = args["dn_outputs"]
nscenes     = args["nscenes"].to_i
nobjects    = args["nobjects"]

# clear dn_outputs

system("rm -r #{dn_outputs}")
system("mkdir #{dn_outputs}")

studios = Dir[File.join(dn_studios, "*.skp")]


studios.each{ |fn_studio|
  studio_name = File.basename(fn_studio).sub(/.skp$/, "")
  (0...nscenes).each{ |s|
    
    fn_output_skp = File.join(dn_outputs, "#{studio_name}_#{s}.skp")
    fn_output_spots = File.join(dn_outputs, "#{studio_name}_#{s}.json")
    fn_output_img = File.join(dn_outputs, "#{studio_name}_#{s}.jpg")
    
    system("cp #{fn_studio} #{fn_output_skp}")
    args = [fn_output_skp, fn_output_spots, fn_output_img, dn_objects, nobjects]  
    CLIUtil.run_file(fn_ruby, args)
  }  
}

=begin
studios.each{ |fn_studio|
  args = [fn_studio, dn_objects, dn_outputs, nscenes, nobjects]  
  CLIUtil.run_file(fn_ruby, args)
}

=end
