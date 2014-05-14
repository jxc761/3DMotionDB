

# this is the first version of draw_camera_group
# the extent of camera motion is defined by a flattened spheroid 
def draw_camera_group(options)
  model = Sketchup.active_model
  group = model.entities.add_group
  group.name= "nplab_camera"
  entities  = group.entities 
  
  alpha     = 0.9
  numsegs   = 24
  height    = 1.65.m
  
  
  # add a material to model
  material = model.materials.add('nplab_camera_material')
  material.color= Sketchup::Color.new(239, 255, 255)      # light yellow 
  material.alpha= alpha
  
  max_r = 2.0.m
  core_sz = 0.1.m
  head_move_r = 0.5.m
  # draw circles at the bottom
  base = entities.add_group
  base.name="nplab_camera_base"
  base_center = [0, 0, 0]
  circle_edge = base.entities.add_circle(base_center, [0, 0, 1], max_r, numsegs)
  circle_face = base.entities.add_face(circle_edge)
  circle_face.pushpull -0.05.m
  
  # draw the upper part
  upper_center = [0, 0, height]
  
  # draw a ball to identicate the range of the head movement 
  core = entities.add_group
  core.name = "nplab_camera_core"
  draw_ball(core.entities, upper_center, core_sz)
  core.material= material  
  
  
  #draw the motion boundary around the core 
  camera_bounds = entities.add_group
  camera_bounds.name = "nplab_camera_bounds"
  draw_ball(camera_bounds.entities, upper_center, head_move_r)
   
  #bound = camera_bounds.entities.add_circle(upper_center, [0, 0, 1], max_r, numsegs)
  #bound_face = camera_bounds.entities.add_face(bound)
  
  #draw a line connecting the base and the camera
  entities.add_line(base_center, upper_center)
  
  group.material=material
  
end

def draw_camera(entities, center, sz)
  draw_ball(entities, center, sz)
end


def draw_ball(entities, center, radius, numsegs = 24)
  n1 = [0, 0, 1]
  n2 = [0, 1, 0]
  c1 = entities.add_circle(center, n1, radius, numsegs)
  c2 = entities.add_circle(center, n2, radius+0.5.m, numsegs)
  face = entities.add_face(c1)
  face.followme(c2)
  entities.erase_entities c2
end



Sketchup.file_new
Sketchup.active_model.entities.clear!
Sketchup.active_model.definitions.purge_unused
Sketchup.active_model.materials.purge_unused
draw_camera_group({})
