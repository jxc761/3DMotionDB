#!/usr/bin/env ruby

require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"
def print_usage
  cmd_name = File.basename(__FILE__)
  puts "./#{cmd_name} <fn_setting>"
end


if ARGV.size != 1
  print_usage()
  exit
end

required = ["fn_conf", "dn_skps", "dn_root_scripts", "dn_root_output"]
args = CLIUtil.get_vars(ARGV[0], required)



fn_conf = args["fn_conf"]
dn_skps = args["fn_skps"]
dn_root_scripts = args["dn_root_scripts"]
dn_root_output  = args["dn_root_output"]

skp_files = Dir[File.join(dn_skps, "*.skp")]

skp_files.each{ |fn_skp|
  name = File.basename(fn_skp).sub(/\.skp$/, "")
  
  sub_output_dir  = File.join(dn_root_output, name)
  
  system("rm -r #{sub_output_dir}")
  system("mkdir #{sub_output_dir}")
  
  cur_scripts_dir = File.join(dn_root_scripts, name)
  script_files = Dir[File.join(cur_scripts_dir, "*.ss.json")]
  
  scripts_file.each{ |fn_script|
    script_name = File.basename(fn_script).sub(/\.ss\.json$/, "")
    cur_output_dir = File.join(sub_output_dir, script_name)
    system("mkdir #{cur_output_dir}")
    
    args = [fn_conf, fn_skp, fn_script, cur_output_dir]
    puts fn_conf
    puts fn_skp
    puts fn_script
    puts cur_output_dir
  }
  
  
} 

