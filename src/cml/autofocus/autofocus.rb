#!/usr/bin/env ruby

require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "./#{cmd_name} <dn_inputs> [<dn_outputs>] <number>  "
end


dn_inputs = ARGV[0]
dn_outputs = ""
numb = 0


if ARGV.size == 2
  dn_outputs = dn_inputs
  numb = ARGV[1]
elsif ARGV.size == 3
  dn_outputs = ARGV[1]
  numb = ARGV[2]
else
  print_usage()
  exit()
end


fn_ruby = File.join( File.dirname(File.absolute_path(__FILE__)), "su_autofocus.rb")

skps = Dir[File.join(dn_inputs, "*.skp")]
skps.each{ |fn_skp|
  skp_name = File.basename(fn_skp).sub(/.skp$/, "")
  fn_cts  = File.join(dn_outputs, "#{skp_name}.cts.json")
  args=[fn_skp, fn_cts, numb]
  CLIUtil.run_file(fn_ruby, args)
}

=begin
studios.each{ |fn_studio|
  args = [fn_studio, dn_objects, dn_outputs, nscenes, nobjects]  
  CLIUtil.run_file(fn_ruby, args)
}

=end
