from pymaxwell import *
import os.path
import glob
import shutil


# mxs path
root_dir = "/home/jxc761/GroundTesting"
src_mxs_dir = os.path.join(root_dir, "StandardMatScene") 
dst_mxs_dir = os.path.join(root_dir, "StandardMatScene_buffer_mxs")

# fn_mxs = os.path.join(src_mxs_dir, "test01.mxs") 
materials_dir = os.path.join(root_dir, "mxm") 
textures_dir = os.path.join(materials_dir, "textures") 


if os.path.isdir(dst_mxs_dir):
	shutil.rmtree(dst_mxs_dir)

shutil.copytree(src_mxs_dir, dst_mxs_dir)
fn_mxs = os.path.join(dst_mxs_dir, "StandardMatScene.mxs")


#open scene
scene = Cmaxwell(mwcallback)
scene.readMXS(fn_mxs)

#add texture path
scene.addSearchingPath(textures_dir)

#get target material
material = scene.getMaterial('preview')

# iterate all materials
mxms = glob.glob(materials_dir + "/*.mxm")
for fn_mxm in mxms:
	print(fn_mxm)

	name,_ = os.path.splitext(os.path.basename(fn_mxm))  
	fn_mxi = os.path.join(name + '.mxi')
	fn_img = os.path.join(name + '.png')
	fn_out = os.path.join(dst_mxs_dir, name + '.mxs')

	ok = material.setReference(1, fn_mxm)
	if ok:
		print("success")

	# 	
	scene.setRenderParameter("MXI FULLNAME", fn_mxi)
	scene.setPath("RENDER", fn_img, 8)
	scene.writeMXS(fn_out)

scene.freeScene()
os.remove(fn_mxs)


