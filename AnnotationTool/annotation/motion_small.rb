module NPLAB
	# two speeds, 12 directions
	def self.generate_small_mts(pairs)
		ranges	= [[0.125.m/120, 0.125.m/120], [0.25.m/120, 0.25.m/120]]
		mts 	= []
		pairs.each{|pair|
			ta = pair[0].transformation
			cur_mts = gen_small_mts(ta, ranges)
			mts << cur_mts
		}
		return mts
	end
	
	def self.gen_small_mts(ta, ranges)
		mts = []
		norm_vds = get_dodecahedron_centers()
		angle = rand() * (3.14 / 12)
		zaxis = Geom::Vector3d.new([rand(), rand(), rand()])
		rotate = Geom::Transformation.rotation(ta.origin, zaxis, angle)
		transformation = rotate * ta
		norm_vds.each{|nvd|
			vd = Geom::Vector3d.new(nvd)
			mv = vd.transform transformation
			ranges.each{|range|
				mv.length= rand() * range[1] + range[0]
				mts << Geom::Transformation.translation(mv)
			}
		}
		return mts
	end
	
	def self.get_dodecahedron_centers()
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
		
		faces = [f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12]
		centers = []
		faces.each{ |face|
			center = [0, 0, 0]
			face.each{|pt|
				center[0] += 0.2 * pt[0]
				center[1] += 0.2 * pt[1]
				center[2] += 0.2 * pt[2]
			}
			centers << center
		}
		return centers
	end
	
end