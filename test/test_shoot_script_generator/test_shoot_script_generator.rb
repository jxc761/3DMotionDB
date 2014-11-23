# load("/Users/Jing/Dropbox/3DMotion/3DMotionDB/test/test_shoot_script_generator/test_shoot_script_generator.rb")
require "nplab.rb"



### build scene
entities = Sketchup.active_model.entities
materials = Sketchup.active_model.materials
entities.clear!
materials.purge_unused

# target
target_material=materials.add("target")
target_material.color = "Magenta"

s = 0.1.m
pts = [[s, s, 0], [-s, s, 0], [-s, -s, 0], [s, -s, 0]];
target = entities.add_group
target.entities.add_face(pts).pushpull(-0.2.m)
target.material= target_material


# gound
ground_material = materials.add("ground")
ground_material.color = "YellowGreen"

s = 1000.m
pts = [[s, s, 0], [s, -s, 0], [-s, -s, 0], [-s, s, 0]];
ground = entities.add_face(pts)
ground.material = ground_material
ground.back_material= ground_material

## generate shoot script
fn_cts = "#{File.dirname(__FILE__)}/input/camera_target_setting.cts.json"
fn_conf   = "#{File.dirname(__FILE__)}/input/shoot_script.conf.json"
dn_output = "#{File.dirname(__FILE__)}/output/"
#Dir.rmdir(dn_output)
#Dir.mkdir(dn_output)
NPLAB::ShootScriptGenerator.generate_shoot_scripts11(fn_conf, fn_cts, dn_output)


# load in one shoot script
fn_script="#{File.dirname(__FILE__)}/output/0_0_0_0.ss.json"
#fn_script="/Users/Jing/Dropbox/3DMotion/3DMotionDB/test/test_shoot_script_generator/output/0_0_0_0.ss.json"
script = NPLAB::CoreIO::CShootScript.load(fn_script)
trace = script.camera_tr.trace
pts = trace.collect{ |position|
  position.origin
}

 Sketchup.active_model.entities.add_edges(pts)