

# this is the first version of draw_camera_group
# the extent of camera motion is defined by a flattened spheroid 
def draw_camera_group(options)
  model = Sketchup.active_model
  group = model.entities.add_group
  group.name= "nplab_camera"
  entities  = group.entities 
  
  core_sz   = options[:core_sz]  == nil ? 0.12.m  : options[:core_sz] 
  #radiuses = [0.5.m, 1.5.m, 2.0.m]
  radiuses  = options[:radiuses] == nil ? [1.5.m] : options[:radiuses]
  xscale    = options[:xscale]   == nil ? 1       : options[:xscale]
  yscale    = options[:yscale]   == nil ? 1       : options[:yscale]
  zscale    = options[:zscale]   == nil ? 0.75    : options[:zscale] 
  height    = options[:height]   == nil ? 1.65.m  : options[:height]
  
  
  alpha     = 0.75
  numsegs   = 24
  
  # add a material to model
  material = model.materials.add('nplab_camera_material')
  material.color= Sketchup::Color.new(220, 220, 120)      # light yellow 
  material.alpha= alpha
  
  # draw circles at the bottom
  base = entities.add_group
  base.name="nplab_camera_base"
  base_center = [0, 0, 0]
  radiuses[0...-1].each{|radius|
    base.entities.add_circle(base_center, [0, 0, 1], radius, numsegs)
  }
  circle_edge = base.entities.add_circle(base_center, [0, 0, 1], radiuses[-1], numsegs)
  circle_face = base.entities.add_face(circle_edge)  
  t = Geom::Transformation.scaling  base_center, xscale, yscale, zscale #transformation
  base.transform! t
  
  # draw the upper part
  upper_center = [0, 0, height]
  
  # draw a core
  core = entities.add_group
  core.name = "nplab_camera_core"
  draw_camera(core.entities, upper_center, core_sz)
  
  #draw the motion boundary around the core 
  camera_bounds = entities.add_group
  camera_bounds.name = "nplab_camera_bounds"
  radiuses.each{|radius|
    draw_ball(camera_bounds.entities, upper_center, radius, 24)
  }
  t = Geom::Transformation.scaling  upper_center, xscale, yscale, zscale
  camera_bounds.transform! t
  camera_bounds.material=material
  
  #draw a line connecting the base and the camera
  entities.add_line(base_center, upper_center)
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
