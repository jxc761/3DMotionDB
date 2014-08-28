require "/Users/Jing/OneDrive/3DMotionDB/src/assembler/assembler.rb"

file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close

fn_studio     = args[0]
dn_objects    = args[1]
dn_outputs    = args[2]
nscenes       = args[3].to_i
nobjects      = args[4].to_i


#NPLAB::Assembler.assemble(fn_skp, fn_spots, fn_image, dn_objects, nobjects)
NPLAB::Assembler.assemble_scenes(fn_studio, dn_objects, dn_outputs, nscenes, nobjects)


exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")
#osascript -e  'tell application "/Applications/SketchUp 2013/SketchUp.app" to quit' 