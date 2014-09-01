#!/usr/bin/env ruby

require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "Usage: "
  puts "  #{cmd_name}  -c <fn_setting>"
  puts "  #{cmd_name}  <dn_studios> <dn_objects> <dn_outputs> <nscenes> <nobjects>"
end


# 
# Parse arguments
# 
required = ["dn_studios", "dn_objects", "dn_outputs", "nscenes", "nobjects"]

args = CLIUtil.parse_args(requried, ARGV)
unless args
  print_usage()
  exit()
end



dn_studios  = args["dn_studios"]
dn_objects  = args["dn_objects"]
dn_outputs  = args["dn_outputs"]
nscenes     = args["nscenes"].to_i
nobjects    = args["nobjects"].to_i


fn_ruby = File.join( File.dirname(File.absolute_path(__FILE__)), "su_assemble.rb")


# clear dn_outputs
system("mkdir #{dn_outputs}")

studios = Dir[File.join(dn_studios, "*.skp")]

studios.each{ |fn_studio|
  studio_name = File.basename(fn_studio).sub(/\.skp$/, "")
  (0...nscenes).each{ |s|
    
    fn_output_skp = File.join(dn_outputs, "#{studio_name}_#{s}.skp")
    fn_output_spots = File.join(dn_outputs, "#{studio_name}_#{s}.json")
    fn_output_img = File.join(dn_outputs, "#{studio_name}_#{s}.jpg")
    
    system("cp #{fn_studio} #{fn_output_skp}")
    args = [fn_output_skp, fn_output_spots, fn_output_img, dn_objects, nobjects]  
    CLIUtil.run_file(fn_ruby, args)
  }  
}

