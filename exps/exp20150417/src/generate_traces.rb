## generate shoot script

root_dir = "#{File.dirname( File.dirname(__FILE__) )}"

fn_conf    = "#{root_dir}/conf.json"
dn_cts   = "#{root_dir}/cts"
dn_outputs = "#{root_dir}/trace"

puts("conf: #{fn_conf}")
puts("Input: #{dn_cts}")
puts("Output:#{dn_outputs}")

if File.directory?(dn_outputs)
  system("rm -r #{dn_outputs}")
end
system("mkdir  #{dn_outputs}")


puts("Begin....")
#NPLAB::ShootScriptGenerator.generate_shoot_scripts11(fn_conf, fn_cts, dn_output)
NPLAB::ShootScriptGenerator.generate_shoot_scripts(fn_conf, dn_cts, dn_outputs)
puts("Finish...")