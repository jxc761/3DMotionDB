from pymaxwell import *
import os.path
import glob
import shutil


# mxs path
root_dir = "/home/jxc761/GroundTesting"
src_mxs_dir = os.path.join(root_dir, "mxs") 
dst_mxs_dir = os.path.join(root_dir, "fixed")

# fn_mxs = os.path.join(src_mxs_dir, "test01.mxs") 
materials_dir = os.path.join(root_dir, "mxm") 
textures_dir = os.path.join(materials_dir, "textures") 


if os.path.isdir(dst_mxs_dir):
	shutil.rmtree(dst_mxs_dir)

shutil.copytree(src_mxs_dir, dst_mxs_dir)
fn_mxs = os.path.join(dst_mxs_dir, "test01.mxs")

#open scene
scene = Cmaxwell(mwcallback)
scene.readMXS(fn_mxs)

#add texture path
scene.addSearchingPath(textures_dir)

# create plane
plane = scene.createMesh("plane", 4, 1, 2, 1)
r = 500
v0 = Cvector( r, 0,  r)
v1 = Cvector(-r, 0,  r)
v2 = Cvector(-r, 0, -r)
v3 = Cvector( r, 0, -r)

normal = Cvector(0, 1, 0)

plane.setVertex(0, 0, v0)
plane.setVertex(1, 0, v1)
plane.setVertex(2, 0, v2)
plane.setVertex(3, 0, v3)

plane.setNormal(0, 0, normal)

plane.setTriangle(0, 0, 1, 2, 0, 0, 0);
plane.setTriangle(1, 2, 0, 3, 0, 0, 0);

# add uvw channel
uvwIndex, ok = plane.addChannelUVW()
u = 2 * r ;
plane.setTriangleUVW(0, uvwIndex, u, u, 0,  0, u, 0,  0, 0, 0)
plane.setTriangleUVW(1, uvwIndex, 0, 0, 0,  u, u, 0,  u, 0, 0)

# add material 
material = scene.createMaterial('plane_material', True)
plane.setMaterial(material)

# iterate all materials
mxms = glob.glob(materials_dir + "/*.mxm")
for fn_mxm in mxms:
	print(fn_mxm)

	name,_ = os.path.splitext(os.path.basename(fn_mxm))   
	fn_out = os.path.join(dst_mxs_dir, name + '.mxs')
	fn_mxi = os.path.join(name + '.mxi')
	fn_img = os.path.join(name + '.png')


	ok = material.setReference(1, fn_mxm)
	if ok:
		print("success")
	
	scene.setRenderParameter("MXI FULLNAME", fn_mxi)
	scene.setPath("RENDER", fn_img, 8)
	scene.writeMXS(fn_out)

scene.freeScene()
os.remove(fn_mxs)