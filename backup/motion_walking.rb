#load("/Users/Jing/Library/Application Support/SketchUp 2013/SketchUp/Plugins/annotation/motion_walking.rb")
module NPLAB
	
	# generate walking motion transformation for a pair
	# srand(@seed)
	def self.generate_walking_mts(pairs, fps=120)
		ranges	= [[0.25.m/fps, 0.25.m/fps],[0.5.m/120, 0.5.m/fps], [1.0.m/120, 1.0.m/fps]]
		mts 	= []
		pairs.each{|pair|
			ta = pair[0].transformation
			cur_mts = gen_walking_mts(ta, ranges)
			mts << cur_mts
		}
		return mts
	end
	
	# three different speeds, eight different direction
	def self.gen_walking_mts(ta, ranges)
		nd = 8
		norm_vds = get_walking_directions(nd)
		
		mts = []
		angle = rand() * (2 * 3.14 / nd)
		rotate = Geom::Transformation.rotation(ta.origin, ta.zaxis, angle)
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
	
	def self.get_walking_directions(n=8)
		vds = []
		delta = 2 * 3.14 / n
		
		(0...n).each{|i|
			x = Math.cos(delta*i)
			y = Math.sin(delta*i)
			z = 0
			vds << Geom::Vector3d.new([x, y, z])
		}
		return vds
	end
	
end