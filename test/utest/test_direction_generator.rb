

def test_generator(generator, eye, up, target)
  group = Sketchup.active_model.entities.add_group()
  directions = generator.generate_directions(eye, up, target)
  directions.each{|d|
    puts("#{d[0]}, #{d[1]}, #{d[2]}")
    group.entities.add_edges(Geom::Point3d.new(eye), Geom::Point3d.new(eye)+d)
  }
end

eye = [-1, 1, 0]
target = [0, 0, 0]
up = [0, 1, 0]

##################
options = {"ndirections" => 8, "plane" => "uv"}
puts("Test CRegularDirectionsGeneratorOnPlane")
generator = NPLAB::ShootScriptGenerator::CRegularDirectionsGeneratorOnPlane.new(options)
test_generator(generator, eye, up, target)

puts("Test CRandomDirectionsGeneratorOnPlane")
generator = NPLAB::ShootScriptGenerator::CRandomDirectionsGeneratorOnPlane.new(options)
test_generator(generator, eye, up, target)

#######################
options = {"ndirections" => 8}
generator = NPLAB::ShootScriptGenerator::CRegularDirectionsGeneratorInSpace.new(options)
test_generator(generator, eye, up, target)


generator = NPLAB::ShootScriptGenerator::CRandomDirectionsGeneratorInSpace.new(options)
test_generator(generator, eye, up, target)

#######################
options={"directions" => ['-x', '-y', '-z']}
generator = NPLAB::ShootScriptGenerator::CSpecialDirectionsGenerator.new(options)
test_generator(generator, eye, up, target)


##############################
faces = NPLAB::ShootScriptGenerator.get_tetrahedron_faces()
group = Sketchup.active_model.entities.add_group()
faces.each{ |face| group.entities.add_face(face)}


faces = NPLAB::ShootScriptGenerator.get_cube_faces()
group = Sketchup.active_model.entities.add_group()
faces.each{ |face| group.entities.add_face(face)}

faces = NPLAB::ShootScriptGenerator.get_dodecahedron_faces()
group = Sketchup.active_model.entities.add_group()
faces.each{ |face| group.entities.add_face(face)}
