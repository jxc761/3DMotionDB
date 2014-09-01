require "#{File.dirname(File.dirname(__FILE__))}/include_nplab_plugins.rb"

file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close


fn_skp     = args[0]
fn_conf    = args[1]
fn_script  = args[2]
dn_outputs = args[3]



Sketchup.open_file(fn_skp)
script = NPLAB::CoreIO::CShootScript.load(fn_script)
conf   = NPLAB::Render::CSURenderConf.load(fn_conf)
render = NPLAB::Render::CSURender.new(conf, script, dn_outputs)
render.render()
