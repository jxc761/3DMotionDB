
def test()
   Sketchup.file_new
   Sketchup.active_model.entities.clear!
   Sketchup.active_model.definitions.purge_unused
   Sketchup.active_model.materials.purge_unused
   
    model = Sketchup.active_model 
	filename = model.path.sub(/\.skp$/,".txt")
    # call:
    #   get_definition
    #   new_instance
    #   set_pairs
    pairs = []
    camera_def = NPLAB.get_definition(model, NPLAB::CN_CAMERA, NPLAB::FN_CAMERA)
    camera_transf = Geom::Transformation.new
    camera =  NPLAB.new_instance(model, camera_def, camera_transf, NPLAB::LN_CAMERA)

    target_def =  NPLAB.get_definition(model, NPLAB::CN_TARGET, NPLAB::FN_TARGET)
    target_transf = Geom::Transformation.translation([0, 5.0.m, 2.m])
    target =  NPLAB.new_instance(model, target_def, target_transf, NPLAB::LN_TARGET)
    
    pairs << [camera, target]
  
    
    target_transf = Geom::Transformation.translation([5.0.m, 0, 2.m])
    target =  NPLAB.new_instance(model, target_def, target_transf, "nplab_target_layer", "1278")
    pairs << [camera, target]
     
    NPLAB.set_pairs(model, pairs)
    
    #filename = model.path.sub(/\.skp$/,".txt")
	filename = '/users/Jing/test.txt'
    NPLAB.save_to_txt(model, filename)

end
  
test()

