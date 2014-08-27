file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close

if args.size < 5
  puts "usage:"
  puts "./#{File.basename(__FILE__)} <fn_studio> <dn_objects> <fn_output_skp> <fn_spots_info> <nobjects>"
  exit()
end

fn_studio     = args[0]
dn_objects    = args[1]
fn_output_skp = args[2]
fn_spots_info = args[3]
nobjects      = args[4]

NPLAB::ObjectScene.assemble(fn_studio, dn_objects, fn_output_skp, fn_spots_info, nobjects)

exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")
