#
def set_custom_environment(path_to_hdr)
	#path_to_hdr="/Users/Jing/Dropbox/3DMotion/3DMotionDB/exps/round01_backup/DH041LL.hdr"

	model=Sketchup.active_model
	
	#set environment 
	mxfilename=MX::Filename.new()
	mxfilename.read_path(path_to_hdr)

	# HDR based lighting
	MX::Util.set_property(model, "environment", "environment.env_type", "imagebased", true)
	MX::Util.set_property(model, "environment", "environment.background.file", mxfilename)
	MX::Util.set_property(model, "environment", "environment.ibl_intensity", 20)
	MX::Util.set_property(model, "environment", "environment.illumination.mode", "background")
	MX::Util.set_property(model, "environment", "environment.refraction.mode", "background")
	MX::Util.set_property(model, "environment", "environment.reflection.mode", "background")

	# ground
	MX::Util.set_property(model, "environment", "environment.groundplane_mode", "custom")
	MX::Util.set_property(model, "environment", "environment.groundplane_color", "255:220:220:220")

	# cur_attr = model.get_attribute("maxwell", "environment")
end


def create_table_plane(model)
	hx = 2.44.m / 2
	hy = 1.91.m / 2 

	pts 	= [ [hx, hy, 0], [hx, -hy, 0], [-hx, -hy, 0], [-hx, hy, 0] ]
	normal 	= Geom::Vector3d.new([0, 0, 1])
	group = model.entities.add_group()
	face = group.entities.add_face(pts)

	if ( face.normal.dot(normal) < 0 )
		face.reverse!
	end

	return [group, face]
end

def run()
    dn_objects  = "/Users/Jing/Dropbox/dataset/objects"
	
	root_dir    = File.dirname( File.dirname(__FILE__) )
	path_to_hdr = File.join(root_dir, "res",  "DH041LL.hdr")
	dn_skps     = File.join(root_dir, "skps")
	dn_spots    = File.join(root_dir, "spots")
	nObjects 	= 5
	nScene      = 5

	(0...nScene).each{ |scene_index|
		Sketchup.file_new

		basename = "scene#{scene_index}"
		fn_skp = File.join(dn_skps, "#{basename}.skp")
		fn_spots = File.join(dn_spots, "#{basename}.spots.json")

		model = Sketchup.active_model
		model.entities.clear!

		group, plane = create_table_plane(model)

		objects = NPLAB::Assembler.assemble_on_plane(model, plane, dn_objects, nObjects)
		# set these objects as the spots and save the information out
    	spots =  NPLAB::CoreIO::CSpots.from_instances(objects)   
    	spots.save(fn_spots)

		set_custom_environment(path_to_hdr)
		group.erase!

		model.save(fn_skp, Sketchup::Model::VERSION_2013)
		model.close()

	}	


end

run()

