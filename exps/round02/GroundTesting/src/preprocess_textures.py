""" 
The texture name in mxm doesn't match the file name in texture collection. 

"""

import re
import glob
import os
import shutil


path_to_textures = "/home/jxc761/GroundTesting/res/textures"
path_to_textures = "/Users/Jing/Dropbox/3DMotion/3DMotionDB/exps/round02/GroundTesting/res/textures"
path_to_outputs  = "/Users/Jing/Dropbox/3DMotion/3DMotionDB/exps/round02/GroundTesting/mxm/textures"

if os.path.isdir(path_to_outputs):
	shutil.rmtree(path_to_outputs)

os.mkdir(path_to_outputs)

files = glob.glob(os.path.join(path_to_textures, '*.png'))
for fn in files:
	name = os.path.basename(fn)

	dd=re.findall(r'\+(\d\d)_', name)
	dst_name=re.sub(r'\+(\d\d)_', '+0' + dd[0] + '_', name)
	dst_name=dst_name.replace('+', '-')
	
	dst_fn = os.path.join(path_to_outputs, dst_name)

	print(fn)
	print(dst_fn)
	shutil.copyfile(fn, dst_fn)


