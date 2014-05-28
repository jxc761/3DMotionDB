# load("/Users/Jing/Library/Application Support/SketchUp 2013/SketchUp/Plugins/annotation/txtio.rb")
# /Users/Jing/Desktop/generate.rb
# recover the scene
model = Sketchup.active_model
filename = "/Users/Jing/Desktop/cityhall/city hall.txt"
NPLAB.load_from_txt(model, filename)


# generate mts 
srand(1234)	
pairs = NPLAB.get_pairs(model)
mts = NPLAB.generate_walking_mts(pairs)
#mts = NPLAB.generate_small_mts(pairs)
# setting option
export_opts = {}
export_opts["width"] = 256
export_opts["height"]  = 256
export_opts["fov"] = 35
export_opts["fps"] = 120
export_opts["path_to_save_to"] = "/Users/Jing/Desktop/cityhall/images"
#export_opts["path_to_save_to"] = "/Users/Jing/Desktop/cityhall/small"
export_opts["duration"] = 1.0
export_opts["pairs"] = pairs
export_opts["mts"] = mts

Sketchup.active_model.active_view.animation = FixationAnimation.new(export_opts)