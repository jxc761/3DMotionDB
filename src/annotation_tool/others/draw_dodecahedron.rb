def draw_dodecahedron()
	p = 1.618
	t = 0.618
	v1 =[ 1, 1, 1]
	v2 =[ 1,-1, 1]
	v3 =[-1,-1, 1]
	v4 =[-1, 1, 1]
	v5 =[ 1, 1,-1]
	v6 =[ 1,-1,-1]
	v7 =[-1,-1,-1]
	v8 =[-1, 1,-1]

	v9 =[ 0, p, t]
	v10=[ 0, p,-t]
	v11=[ 0,-p,-t]
	v12=[ 0,-p, t]



	v13=[ t, 0, p]
	v14=[ t, 0,-p]
	v15=[-t, 0,-p]
	v16=[-t, 0, p]

	v17=[ p, t, 0]
	v18=[ p,-t, 0]
	v19=[-p,-t, 0]
	v20=[-p, t, 0]


	f1 =[v1 , v17, v18, v2 , v13]
	f2 =[v1 , v9 , v10, v5 , v17]
	f3 =[v1 , v13, v16, v4 , v9 ]
	f4 =[v2 , v12, v3 , v16, v13]
	f5 =[v2 , v18, v6 , v11, v12]
	f6 =[v3 , v12, v11, v7 , v19]
	f7 =[v3 , v16, v4 , v20, v19]
	f8 =[v4 , v20, v8 , v10, v9 ]
	f9 =[v5 , v14, v6 , v18, v17]
	f10=[v5 , v10, v8 , v15, v14]
	f11=[v6 , v14, v15, v7 , v11]
	f12=[v7 , v19, v20, v8 , v15]

	entities=Sketchup.active_model.entities
	face = entities.add_face f1
	face = entities.add_face f2
	face = entities.add_face f3
	face = entities.add_face f4
	face = entities.add_face f5
	face = entities.add_face f6
	face = entities.add_face f7
	face = entities.add_face f8
	face = entities.add_face f9
	face = entities.add_face f10
	face = entities.add_face f11
	face = entities.add_face f12
end
