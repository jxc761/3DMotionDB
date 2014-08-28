require "/Users/Jing/OneDrive/3DMotionDB/src/assembler/assembler.rb"

file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close

fn_skp     = args[0]
fn_spots   = args[1]
fn_img     = args[2]
dn_objects = args[3]
nobjects   = args[4].to_i


NPLAB::Assembler.assemble(fn_skp, fn_spots, fn_img, dn_objects, nobjects)
#NPLAB::Assembler.assemble_scenes(fn_studio, dn_objects, dn_outputs, nscenes, nobjects)

exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")
#osascript -e  'tell application "/Applications/SketchUp 2013/SketchUp.app" to quit' 