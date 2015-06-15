# auto_focus 

def run()
   
	
	root_dir    = File.dirname( File.dirname(__FILE__) )
	dn_skps     = File.join(root_dir, "skps")
	dn_cts      = File.join(root_dir, "cts")
	nScene =5
	numb = 2
	(0...nScene).each{ |scene_index|
		basename = "scene#{scene_index}"
		
		fn_skp = File.join(dn_skps, "#{basename}.skp")
		
		fn_cts = File.join(dn_cts, "#{basename}.cts.json")

		Sketchup.open_file(fn_skp)

		position = Geom::Transformation.new(Geom::Point3d.new([0, 2.44.m, 1.0.m]), Geom::Vector3d.new([0, 0, 1]));
		camera  = NPLAB::CoreIO::CCamera.new("1", position)
		
		model = Sketchup.active_model
		cts =NPLAB::Autofocus.autofocus_in_model_with_cameras(model, camera, numb)
		cts.save(fn_cts)
		model.close()

	}	


end

run()