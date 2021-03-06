require "#{File.dirname(File.dirname(__FILE__))}/include_nplab_plugins.rb"


file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close


fn_skp = args[0]
fn_cts = args[1]
numb   = args[2].to_i

NPLAB::Autofocus.autofocus(fn_skp, fn_cts, numb)

if Sketchup.version_number > 14000000 
	Sketchup.quit
else
	exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")
end 
#system("osascript -e " + "'" + 'tell application "/Applications/SketchUp 2013/SketchUp.app" to quit' + "'")