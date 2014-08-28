module NPLAB
  
  module Assembler
    
    # The interface of core alogrithms of placing objects onto a face.
    class CLayout
      # Any subclass must implement this interface.
      def self.place(plane, radii, opts)
        raise "this is a abstract method"
      end
      
      # For testing place()
      def self.testPlace()
        depth = 3.m
        width = 4.5.m

        model = Sketchup.active_model
        entities = model.active_entities
        pts = []
        pts[0] = [0, 0, 0]
        pts[1] = [0, width, 0]
        pts[2] = [0, width, depth]
        pts[3] = [0, 0, depth]
        # Add the face to the entities in the model
        face = entities.add_face pts

        radii = [1.0.m, 0.8.m, 0.5.m]
        centers = place(face, radii)

        if centers == nil
          puts "cannot find a valid layout"
          return false
        end

        normal= face.normal
        (0...radii.size).each{|i|
          entities.add_circle(centers[i], normal,radii[i])
        }
        return true
      end
      #
      
      #
      def self.get_bound_vertices(plane)
        pts = plane.outer_loop.vertices.collect{|v| v.position}
        return pts
      end


      def self.notOutBound(c, r, pts)
        n = pts.size
        (0...n).each{ |k|
          line = [pts[k], pts[(k+1)%n]]
          d = c.distance_to_line(line)
          if d < r
            return false
          end
        }
        return true
      end

      def self.notIntersect(c, r, centers, radii)
        n=centers.size
       

        # test whether circle i intersects other circles
        (0...n).each{ |i|
          next unless centers[i]
                    
          d = c.distance(centers[i])
          if d < r + radii[i]
            return false
          end
        }
        return true
      end
      


    end


    class CRandomLayout < CLayout
      
      
      def self.place(face, radii, opts={"maxIt"=> 100000})
   
        maxIt = opts["maxIt"]
    
        # get all bounding vertcies(points)
        points = get_bound_vertices(face)
    
        # intial centers of all circles
        n = radii.size
        centers = Array.new(n){nil}
        
        # arrange objects in order of decreasing size
        idx = (0...n).to_a.sort_by{|i| -radii[i]}
        idx.each{ |i|
          
          puts "find a place for #{i}"
          puts radii[i]
          for it in (0...maxIt)
            # centers[i] = makePosition(points)
            c = Utils.rand_pick(points)
        
            # test the circle is in the face or intesects with other circles
            if ( notOutBound(c, radii[i], points) && notIntersect(c, radii[i], centers, radii) )
              centers[i] = c
              break
            end
               
          end
          
          # have not found any fesible position for the i-th circle
          if centers[i] == nil
            return nil
          end
        }
       
        return centers
      end
  
  
    end
    
    
  end
end

=begin
    class CWordleLayout < CLayout
      # Archimedean spiral
      # r = a+b\theta
      # with real numbers a and b. 
      # Changing the parameter a will turn the spiral, while b controls the distance between successive turnings.
      def self.archimedean_spiral(a, b, theta)
    
        r = a + b * theta
        x = r * Math.cos(theta)
        y = r * Math.sin(theta)
        z = 0
        pt = Geom::Point3d.new([x, y, z])
      end
  
  
      def self.place(face, radii, opts={})
        default = {"increase_rate"=> radii[0], "dtheta" =>  Math::PI / 8, maxIt => 100000}
        opts    = default.merge(opts)
        
        # set parameters
        b       = opts["increase_rate"]
        dtheta  = opts["dtheta"]
        maxIt   = opts["maxIt"]
  
        # get all bounding vertcies(points)
        points = get_bound_vertices(face) 
        normal = face.normal
    
        # intial centers of all circles 
        n = radii.size
        centers = Array.new(n){nil}
    
        # arrange circles in order
        idx = (0...n).to_a.sort_by{|i| -radii[i]}
        idx.each{ |i|
      
          for it in (0...maxIt)
            centers[i]= place_ith_circle(i, centers, radii, points, normal, b, dtheta)
            if centers[i] != nil
              break
            end
          end
      
          if centers[i] ==  nil
            return nil
          end
        }
        return centers
      end
  
      def self.place_ith_circle(i, centers, radii, points, normal, b, dtheta)
        centers[i] = nil
        c = rand_pick(points)
    
        # get the coordinate tranformation
        transf = Geom::Transformation.new(c, normal)
    
        # find the maxium r
        maxr = -1
        points.each{ |pt|
          d    = c.distance(pt)
          maxr = d > maxr ? d : maxr
        }
        maxIt = ( maxr / (b * dtheta) ).ceil
    
        (1..maxIt).each{
          # test the circle is in the face
          if ( notOutBound(c, radii[i], points) && notIntersect(c, radii[i], centers, radii, i) )
            centers[i] = c
            break
          end 
          
          # update the position
          theta = i * dtheta
          pt = archimedean_spiral(0, b, theta)
          c = pt.transform(transf)
        } 
        return centers[i]
      end
  
    end
=end
  