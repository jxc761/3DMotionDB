
file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close


fn_conf    = args[0]
fn_skp     = args[1]
fn_script  = args[2]
dn_outputs = args[3]



puts fn_conf
puts fn_skp
puts fn_script
puts dn_outputs

Sketchup.open_file(fn_skp)

conf        = NPLAB::CoreIO.CSURenderConf.load(fn_setting)
script      = NPLAB::CoreIO.CShootScript.load(fn_script)
render      = CSURender.render(conf, script, dn_outputs)
Sketchup.active_model.active_view.animation = render


