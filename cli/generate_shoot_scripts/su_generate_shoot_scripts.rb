require "#{File.dirname(File.dirname(__FILE__))}/include_nplab_plugins.rb"


file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close


fn_conf     =args[0]
dn_cts      =args[1]
dn_outputs  =args[2]

#Sketchup.file_new
model = Sketchup.active_model

NPLAB::ShootScriptGenerator.generate_shoot_scripts(fn_conf, dn_cts, dn_outputs)

#system("osascript -e  "+ "'" + 'tell application "/Applications/SketchUp 2013/SketchUp.app" to quit'+"' ")
exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")