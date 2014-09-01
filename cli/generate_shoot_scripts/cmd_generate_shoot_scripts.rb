#!/usr/bin/env ruby


require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "./#{cmd_name} -c <fn_setting>"
  puts "./#{cmd_name} <fn_shoot_script_configuration> <dn_camera_target_setting> <dn_root_outputs>"
end

# 
# Parse arguments
# 
required = ["fn_shoot_script_configuration", "dn_camera_target_setting", "dn_root_outputs"]

args = CLIUtil.parse_args(requried, ARGV)
unless args
  print_usage()
  exit()
end

fn_ruby =File.join( File.dirname(File.absolute_path(__FILE__)), "su_generate_shoot_scripts.rb")

fn_conf     =args["fn_shoot_script_configuration"]
dn_cts      =args["dn_camera_target_setting"]
dn_outputs  =args["dn_root_outputs"]

CLIUtil.run_file(fn_ruby, [dn_conf, dn_cts, dn_outputs])
