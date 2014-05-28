	def test_gen_walking_mts()
		group = Sketchup.active_model.entities.add_group
		entities = group.entities
		w = 100
		h = 250
	 	entities.add_face([0, 0, 0], [w, 0, 0], [w, h, 0], [0, h, 0])
		
		t1 = Geom::Transformation.rotation([0, 0, 0], [1, 1, 1], 20)
		t2 = Geom::Transformation.translation([1, 2, 3])
		t3 = Geom::Transformation.rotation([1, 1, 2], [0, 0, 1], 30)
		t = t3 * t1 * t2
		
		group.transformation= t
	
		mts = gen_walking_mts(group.transformation)
		moving_group = group.copy	
		cur_t = group.transformation
		moving_group.transformation = mts[1] * cur_t
	end
	