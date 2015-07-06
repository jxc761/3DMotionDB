from pymaxwell import *



import os
import os.path
import glob
import re
import shutil
import json



NSTEPS    = 2 # NOT CHANGE 
FILMWIDTH = 0.024 
FILMHEIGHT= 0.024
XRES      = 64
YRES      = 64

PIXELASPECT    = 1.0
PROJECTIONTYPE = 0  

ISO = 100
PDIAPHRAGMTYPE = 'CIRCULAR'
NBLADES=0

ANGLE =180
FPS = 30 
SHUTTER = 1.0  * ANGLE / ( 360 * FPS)
FSTOP=5.6

FOCALLENGTH = 0.050



meters_per_inch = 0.0254

def to_vec(pt):
	return Cvector(pt[0], pt[2], -pt[1])

def inches_to_meters(pt):
	return [meters_per_inch * x for x in pt]


def generate_fames(pzCurMxs, pzCurTraceDir, pzFramesDir, scene_name):
	print(pzCurMxs)
	print(pzCurTraceDir)
	print(pzFramesDir)
	print(scene_name)
	for pzCurTraceFile in glob.glob(os.path.join(pzCurTraceDir, "*.ss.json") ):
		#
		print(pzCurTraceFile)
		trace_name = re.sub('.ss.json$', "", os.path.basename(pzCurTraceFile) )

		pzCurFramesDir = os.path.join(pzFramesDir, scene_name, trace_name)
		print(pzCurFramesDir)
		
		if not os.path.isdir(pzCurFramesDir):
			os.system('mkdir -p ' + pzCurFramesDir)

	
		# shutil.rmtree(pzCurFramesDir, True)
		# shutil.copytree(cur_dir, pzCurFramesDir)


		# load shoot script 
		ss          	= json.loads(open(pzCurTraceFile, 'r').read())
		target_pos 	    = ss['target']['position']['origin']
		target_pos_vec  = to_vec(inches_to_meters(target_pos))
		trace       	= ss['camera_trajectory']['trace']

		# add cameras
		for id in range(1, len(trace), 2):

			# open scene
			scene = Cmaxwell(mwcallback)
			ok = scene.readMXS(pzCurMxs)
			if ok == 0:
				print("Error reading scene: {0}".format(pzCurMxs))
				continue 
			scene.setRenderParameter('DO MOTION BLUR', 1)
			
			new_camera = scene.addCamera("frame", 2, SHUTTER, FILMWIDTH, FILMHEIGHT, ISO, PDIAPHRAGMTYPE, ANGLE, NBLADES, FPS, XRES, YRES, PIXELASPECT)
			new_camera.setActive()

			trace_pt = trace[id-1]
			camera_pos = trace_pt['origin']
			camera_up = trace_pt['zaxis']
			camera_pos_vec = to_vec(inches_to_meters(camera_pos))
			camera_up_vec = to_vec(camera_up)
			new_camera.setStep(0,camera_pos_vec,target_pos_vec,camera_up_vec,FOCALLENGTH,FSTOP,0)

			trace_pt = trace[id]
			camera_pos = trace_pt['origin']
			camera_up = trace_pt['zaxis']
			camera_pos_vec = to_vec(inches_to_meters(camera_pos))
			camera_up_vec = to_vec(camera_up)
			new_camera.setStep(1,camera_pos_vec,target_pos_vec,camera_up_vec,FOCALLENGTH,FSTOP,1)


			# trace_pt = trace[id+1]
			# camera_pos = trace_pt['origin']
			# camera_up = trace_pt['zaxis']
			# camera_pos_vec = to_vec(inches_to_meters(camera_pos))
			# camera_up_vec = to_vec(camera_up)
			# new_camera.setStep(2,camera_pos_vec,target_pos_vec,camera_up_vec,focalLength,fStop,1)


			#write out
			new_mxs_path = os.path.join(pzCurFramesDir, "frame{0:03d}.mxs".format(id/2))
			print(new_mxs_path)
			ok = scene.writeMXS(new_mxs_path);
			if ok == 0:
				print("Error saving frame")

			scene.freeScene()
def main():
	pzRootDir =  "/home/jxc761/GroundTesting"
	pzMxsDir = os.path.join(pzRootDir, "buffer_mxs_64x64")
	pzTraceDir = os.path.join(pzRootDir, "trace", "config_0")
	pzFramesDir = os.path.join(pzRootDir, "frames", "config_0")

	if os.path.isdir(pzFramesDir):
		shutil.rmtree(pzFramesDir)

	os.mkdir(pzFramesDir) 
	
	for pzCurMxs in  glob.glob( os.path.join(pzMxsDir, "*.mxs") ):
		print(pzCurMxs)
		scene_name,_ = os.path.splitext( os.path.basename(pzCurMxs) ) 
		generate_fames(pzCurMxs, pzTraceDir, pzFramesDir, scene_name)
 	

main()
