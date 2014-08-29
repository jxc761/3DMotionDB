require "/Users/Jing/OneDrive/3DMotionDB/src/autofocus/autofocus.rb"



file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close


fn_skp = args[0]
fn_cts = args[1]
numb   = args[2].to_i

NPLAB::Autofocus.autofocus(fn_skp, fn_cts, numb)
exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")
#system("osascript -e " + "'" + 'tell application "/Applications/SketchUp 2013/SketchUp.app" to quit' + "'")