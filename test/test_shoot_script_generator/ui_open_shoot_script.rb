menu = UI.menu("Tools")
item = menu.add_item("Open camera trace File") { 
    model     = Sketchup.active_model
		directory = File.dirname(model.path)
    
    fn_script = UI.openpanel("Load Setting", directory, "JSON|*.ss.json||")
		if fn_script
      script = NPLAB::CoreIO::CShootScript.load(fn_script)
      trace = script.camera_tr.trace
      pts = trace.collect{ |position|
        position.origin
      }
    
      group  = Sketchup.active_model.entities.add_group
      entities = group.entities
      entities.add_edges(pts)
      entities.add_cline(script.camera.location, script.target.location)
		end
    

}
