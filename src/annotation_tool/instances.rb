require "sketchup"

module NPLAB
  # if an instance is deleted, we need to remove all related pairs in the model.
  #

  # A simple method to remove all instances of the component with name
  #
  #
  def self.remove_all_instances(model, component_name)
    definition = model.definitions[component_name]
    if definition == nil
      return nil
    end

    instances = definition.instances
    instances.each{|inst| inst.erase!}
  end

  # Get the definition of a component by its name. If there is no definition of
  # the compenent in the model, it will load it from the given path.
  #
  def self.get_definition(model, component_name, component_path)
    definition = model.definitions[component_name]
    if definition == nil
      definition = model.definitions.load(component_path)
    end
    return definition
  end

  # Add a new instance to the model
  #
  #
  def self.new_instance(model, definition, transformation, layer_name, id=Time.now.to_i.to_s)
    inst = model.entities.add_instance(definition, transformation)
    inst.set_attribute(DICT_NAME, AN_ID, id)
   # inst.add_observer(CEntityObserver.new)

    layer=model.layers[layer_name]
    if  layer == nil
      layer=model.layers.add(layer_name)
    end
    inst.layer=layer
    return inst
  end

  # Get instance_id 
  def self.get_id(inst)
	 return inst.get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s)	   
  end
  
  # Find the instance with the given id
  #
  def self.find_instance(model, component_name, id)
    definition = model.definitions[component_name]
    if definition == nil
      return nil
    end

    instances = definition.instances
    instances.each{|inst|
      cur_id = inst.get_attribute(DICT_NAME, AN_ID, Time.now.to_i.to_s)
      if cur_id == id
      return inst
      end
    }
    return nil
  end

  # Get the position of the eye
  #
  def self.get_eye_location(camera)
    if camera == nil
      return nil
    end
    t = camera.transformation
    ve = t.zaxis.clone
    ve.length= 1.7.m
    eye_position = t.origin + ve
  end
  
  
  ####################################################

  ####################################################
  
  
  def self.get_up(camera)
      if camera == nil
        return nil
      end
	  
	  camera.transformation.zaxis
  end
  
  
  def self.get_target_position(target)
    t = target.transformation
    return t.origin
  end
  
  def self.get_target_up(target)
    t = target.transformation
    return t.zaxis
  end



  def self.guess_target(camera)
    eye   = get_eye_location(camera)
    up    = get_up(camera)
    axes  = up.axes

    vx = axes[0]
    vy = axes[1]


    bhidden = camera.hidden?

    camera.hidden=true

    # directions = [ []]

    hit = nil
    while not hit
      theta = rand * 2 * Math::PI
      vd = Geom::Vector3d.linear_combination(Math.cos(theta), vx, Math.sin(theta), vy)
      hit =Sketchup.active_model.raytest([eye, vd])
    end
    target = hit[0]

    camera.hidden = bhidden
    return target
  end

  def self.guess_direction(old_camera, camera)
    bhidden = camera.hidden?
    camera.hidden=true

    eye = get_eye_location(camera)
    up = get_up(camera)
    
    axes  = up.axes
    
    
    vx = axes[0]
    vy = axes[1]

    
    n = 16

    maxDist = 0;
    guess = vx;
    (0...n).each{|i| 
      theta = i * 2 * Math::PI / n 
      vd    = Geom::Vector3d.linear_combination(Math.cos(theta), vx, Math.sin(theta), vy)
      hit   = Sketchup.active_model.raytest([eye, vd])
      if hit != nil 
        dist = hit[0].distance(eye) 

        guess   = dist > maxDist ? vd : guess
        maxDist = dist > maxDist ? dist : maxDist 
      end
    }
    
    camera.hidden=bhidden
    return guess
  end

  def self.change_to_camera_view(old_camera, camera)
    #old_target = old_camera.target
    #old_eye    = old_camera.eye
    #old_fov    = old_camera.fov
    #old_f      = old_camera.focal_length

    #puts(old_f)
    
    eye  = get_eye_location(camera)
    up   = get_up(camera)

    # guess target 
    vd     = guess_direction(old_camera, camera)
    dist   = old_camera.eye.distance(old_camera.target)
    target = eye.offset(vd, dist)


    new_view_camera = Sketchup::Camera.new(eye, target, up)

    return new_view_camera; 
  end
  
end