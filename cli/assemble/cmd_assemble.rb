#!/usr/bin/env ruby

require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "Usage: "
  puts "  #{cmd_name}  -c <fn_setting>"
  puts "  #{cmd_name}  <dn_studios> <dn_objects> <dn_outputs_skps> <dn_output_spots> <dn_output_previews> <nscenes> <nobjects>"
end


# 
# Parse arguments
# 
required = ["dn_studios", "dn_objects", "dn_output_skps", "dn_output_spots", "dn_output_previews", "nscenes", "nobjects"]

args = CLIUtil.parse_args(required, ARGV)
unless args
  print_usage()
  exit()
end

args.each_pair{ |key, value|
  puts "#{key}:#{value}"
}

dn_studios        = args["dn_studios"]
dn_objects        = args["dn_objects"]
dn_output_skps    = args["dn_output_skps"]
dn_output_spots   = args["dn_output_spots"]
dn_output_preview = args["dn_output_previews"]

nscenes     = args["nscenes"].to_i
nobjects    = args["nobjects"]


fn_ruby = File.join( File.dirname(File.absolute_path(__FILE__)), "su_assemble.rb")


# clear dn_outputs
# system("mkdir #{dn_outputs}")

studios = Dir[File.join(dn_studios, "*.skp")]

studios.each{ |fn_studio|
  studio_name = File.basename(fn_studio).sub(/\.skp$/, "")
  (0...nscenes).each{ |s|
    
    fn_output_skp   = File.join(dn_output_skps,     "#{studio_name}_#{s}.skp")
    fn_output_spot  = File.join(dn_output_spots,    "#{studio_name}_#{s}.spots.json")
    fn_output_img   = File.join(dn_output_preview,  "#{studio_name}_#{s}.jpg")
    
    system("cp #{fn_studio} #{fn_output_skp}")
    args = [fn_output_skp, fn_output_spot, fn_output_img, dn_objects, nobjects]  
    CLIUtil.run_file(fn_ruby, args)
  }  
}

