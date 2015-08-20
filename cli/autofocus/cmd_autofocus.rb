#!/usr/bin/env ruby

require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "./#{cmd_name} -c <fn_setting>"
  puts "./#{cmd_name} <dn_inputs> <dn_outputs> <number>"
end

# 
# Parse arguments
# 
required = ["dn_inputs", "dn_outputs", "numb"]

args = CLIUtil.parse_args(required, ARGV)
unless args
  print_usage()
  exit()
end


# args.each_pair{ |key, value|
#   puts "#{key}:#{value}"
# }

dn_inputs = args["dn_inputs"]
dn_outputs = args["dn_outputs"]
numb = args["numb"].to_i

#
# begin processing
#
fn_ruby = File.join( File.dirname(File.absolute_path(__FILE__)), "su_autofocus.rb")

skps = Dir[File.join(dn_inputs, "*.skp")]
skps.each{ |fn_skp|
  skp_name  = File.basename(fn_skp).sub(/\.skp$/, "")
  fn_cts    = File.join(dn_outputs, "#{skp_name}.cts.json")
  if (File.exist?(fn_cts))
    next
  end

  args      =[fn_skp, fn_cts, numb]
  CLIUtil.run_file(fn_ruby, args)
}


