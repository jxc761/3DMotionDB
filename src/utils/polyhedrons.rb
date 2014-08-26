module NPLAB
  module Utils
    
    def self.get_tetrahedron_vetices()
      inv_sqrt_2 = 1.0/Math.sqrt(2)
      v1 = [ 1,  0, 0-inv_sqrt_2]
      v2 = [-1,  0, 0-inv_sqrt_2]
      v3 = [ 0,  1,   inv_sqrt_2]
      v4 = [ 0, -1,   inv_sqrt_2]
      return [v1, v2, v3, v4]
    end

    def self.get_tetrahedron_faces()
      inv_sqrt_2 = 1.0/Math.sqrt(2)
      v1 = [ 1,  0, 0-inv_sqrt_2]
      v2 = [-1,  0, 0-inv_sqrt_2]
      v3 = [ 0,  1, inv_sqrt_2]
      v4 = [ 0, -1, inv_sqrt_2]
      
      f1 = [v1, v2, v3]
      f2 = [v1, v2, v4]
      f3 = [v1, v3, v4]
      f4 = [v2, v3, v4]
      return [f1, f2, f3, f4]
    end
    
    def self.get_tetrahedron_centers()
      return get_centers(get_tetrahedron_faces())
    end
    def self.get_cube_vetices()
      v1 =[ 1, 1, 1]
      v2 =[ 1,-1, 1]
      v3 =[-1,-1, 1]
      v4 =[-1, 1, 1]
      v5 =[ 1, 1,-1]
      v6 =[ 1,-1,-1]
      v7 =[-1,-1,-1]
      v8 =[-1, 1,-1]
      return [v1, v2, v3, v4, v5, v6, v7, v8]
    end
     
    def self.get_cube_faces()
      v1 =[ 1, 1, 1]
      v2 =[ 1,-1, 1]
      v3 =[-1,-1, 1]
      v4 =[-1, 1, 1]
      v5 =[ 1, 1,-1]
      v6 =[ 1,-1,-1]
      v7 =[-1,-1,-1]
      v8 =[-1, 1,-1]
      
      f1 = [v1, v2, v3, v4]
      f2 = [v1, v2, v6, v5]
      f3 = [v1, v3, v8, v5]
      f4 = [v2, v3, v7, v6]
      f5 = [v3, v4, v8, v7]
      f6 = [v5, v6, v7, v8]
      return [f1, f2, f3, f4, f5, f6]
    end
    
    def self.get_cube_centers()
      return get_centers(get_cube_faces())
    end

    def self.get_dodecahedron_vetices()
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

      return [v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20]
    end

    def self.get_dodecahedron_faces()
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
      return faces
    end
    
    def self.get_dodecahedron_centers()
      return get_centers(get_dodecahedron_faces())
    end
    
    private
    def self.get_centers(faces)

      centers = []
      faces.each{ |face|
        center = [0, 0, 0]
        inv_z  = 1.0 / face.size
        face.each{|pt|
          center[0] += inv_z * pt[0]
          center[1] += inv_z * pt[1]
          center[2] += inv_z * pt[2]
        }
        centers << center
      }
      return centers
    end
    
    
  end
    
end