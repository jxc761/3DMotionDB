#!/usr/bin/env ruby

require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "./#{cmd_name} -c <fn_setting>"
  puts "./#{cmd_name} <fn_render_conf> <dn_skps> <dn_root_scripts> <dn_root_outputs>"
end

# 
# Parse arguments
# 
required = ["fn_render_conf", "dn_skps", "dn_root_scripts", "dn_root_outputs"]

args = CLIUtil.parse_args(required, ARGV)
unless args
  print_usage()
  exit()
end
args.each_pair{ |key, value|
  puts "#{key}:#{value}"
}


fn_render_conf  = args["fn_render_conf"]
dn_skps         = args["dn_skps"]
dn_root_scripts = args["dn_root_scripts"]
dn_root_outputs = args["dn_root_outputs"]


fn_ruby = "#{File.dirname(File.absolute_path(__FILE__))}/su_render.rb"


# begin process

skp_files = Dir[File.join(dn_skps, "*.skp")]
skp_files.each{ |fn_skp|
  
  name = File.basename(fn_skp).sub(/\.skp$/, "")
  
  sub_output_dir  = File.join(dn_root_outputs, name)
  
  system("rm -r #{sub_output_dir}")
  system("mkdir #{sub_output_dir}")
  
  cur_scripts_dir = File.join(dn_root_scripts, name)
  script_files = Dir[File.join(cur_scripts_dir, "*.ss.json")]
  
  script_files.each{ |fn_script|
    script_name = File.basename(fn_script).sub(/\.ss\.json$/, "")
    cur_output_dir = File.join(sub_output_dir, script_name)
    system("mkdir #{cur_output_dir}")
    
    args = [fn_skp, fn_render_conf, fn_script, cur_output_dir]
    puts fn_render_conf
    puts fn_skp
    puts fn_script
    puts cur_output_dir
    
    CLIUtil.run_file(fn_ruby, args)
  }
  
} 

