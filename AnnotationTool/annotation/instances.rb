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
  def self.get_eye_position(camera)
    if camera == nil
      return nil
    end
    t = camera.transformation
    ve = t.zaxis.clone
    ve.length= 1.7.m
    eye_position = t.origin + ve
  end

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
  
end