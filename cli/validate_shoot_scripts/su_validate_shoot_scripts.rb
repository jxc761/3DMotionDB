require "#{File.dirname(File.dirname(__FILE__))}/include_nplab_plugins.rb"

file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close


fn_skp     = args[0]
dn_scripts = args[1]
dn_outputs = args[2]

NPLAB::ShootScriptValidation.validate_scripts(fn_skp, dn_scripts, dn_outputs)
exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")