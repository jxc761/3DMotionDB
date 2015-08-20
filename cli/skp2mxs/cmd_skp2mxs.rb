require "#{File.dirname(File.dirname(File.absolute_path(__FILE__)))}/util.rb"



def print_usage
  cmd_name = File.basename(__FILE__)
  puts "./#{cmd_name} -c <fn_setting>"
  puts "./#{cmd_name} <dn_skps> <dn_root_mxs>"
end


# 
# Parse arguments
# 
required = ["dn_skps", "dn_root_mxs"]

args = CLIUtil.parse_args(required, ARGV)
unless args
  print_usage()
  exit()
end

dn_skps     = args["dn_skps"]
dn_root_mxs = args["dn_root_mxs"]


#
# begin processing
#
fn_ruby = File.join( File.dirname(File.absolute_path(__FILE__)), "su_skp2mxs.rb") 
fn_skps = Dir[File.join(dn_skps, "*.skp")]
total   = fn_skps.length

fn_skps.each_index{ |i|

  fn_skp = fn_skps[i]
 
  name = File.basename(fn_skp).sub(/\.skp$/, "")
  dn_mxs = File.join(dn_root_mxs, name)
  fn_mxs = File.join(dn_mxs, "#{name}.mxs")

  if File.exist?(fn_mxs)
  	puts("#{i}/#{total}: #{fn_mxs} exists!")
  	next
  end

  args = [fn_skp, dn_mxs]
  CLIUtil.run_file(fn_ruby, args)

  puts("#{i}/#{total}: #{fn_skp} processed!")
}