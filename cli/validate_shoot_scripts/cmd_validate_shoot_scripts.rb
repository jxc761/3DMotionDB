
require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "./#{cmd_name} -c <fn_setting>"
  puts "./#{cmd_name} <dn_skps> <dn_scripts> <dn_outputs>"
end

# 
# Parse arguments
# 
required = ["dn_skps", "dn_scripts" "dn_outputs"]

args = CLIUtil.parse_args(required, ARGV)
unless args
  print_usage()
  exit()
end
args.each_pair{ |key, value|
  puts "#{key}:#{value}"
}

fn_ruby = "#{File.dirname(File.absolute_path(__FILE__))}/su_validate_shoot_scripts.rb"

skp_files= Dir[File.join(dn_skps, "*.skp")]
skp_files.each{ |fn_skp|
  model_name = File.basename(fn_skp).sub(/\.skp$/, "")
  dn_cur_scripts = File.join(dn_scripts, model_name)
  dn_cur_outputs = File.join(dn_outputs, model_name)
  
  system('rm -r "' + dn_cur_output + '""')
  system('mkdir -p "' + dn_cur_output + '"')
  
  cur_args = [fn_skp, dn_cur_scripts, dn_cur_outputs]
  
  CLIUtil.run_file(fn_ruby, cur_args)
}