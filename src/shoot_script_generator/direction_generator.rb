module NPLAB
  module ShootScriptGenerator
    
    
    class CDirectionsGenerator
      def initialize(options={})
        raise "Interface"
      end
    
      def generate_directions(eye, up, target)
        transf = get_transformation(eye, up, target)
        ds = get_canonical_directions().collect{ |direction|
          direction.transform(transf)
        }
        return ds
      end
    
      def get_transformation(eye, up, target)
        raise "Interface"
      end
    
      def get_canonical_directions()
        raise "Interface"
      end
      
      
      def build_uvw_coordinate_system(eye, up, target)
        eye     = Geom::Point3d.new(eye)
        target  = Geom::Point3d.new(target)
        up      = Geom::Vector3d.new(up)
        
        w = (target - eye).normalize
        v = w.cross(up).normalize
        u = v.cross(w).normalize
        return Geom::Transformation.new(u, v, w, eye)
      end 
      
      
      def build_xyz_coordinate_system(eye, up, target)
        
        eye     = Geom::Point3d.new(eye)
        target  = Geom::Point3d.new(target)
        up      = Geom::Vector3d.new(up)
        
        w = (target - eye).normalize
        
        x = up.cross(w).normalize
        y = up.normalize
        z = x.cross(y).normalize

        return Geom::Transformation.new(x, y, z, eye)
      end
      
    end
  
    class CDirectionsGeneratorOnPlane < CDirectionsGenerator
      def initialize(options={})
        defaults = {"ndirections" => 8, "plane" => "zx"}
        options =  defaults.merge(options)
      
        @ndirections =  options["ndirections"]
        
        @plane = options["plane"]
        
        #hash={"u"=>"x", "v" => "y", "w"=> "z"}
        #@plane  = options["plane"].gsub(/u|v|w/){|m| hash[m]}
      end
    
      def get_canonical_directions()
        d_rad = 2 * Math::PI / @ndirections
    
        directions = (0...@ndirections).collect{ |ni|
          a = d_rad * ni  # angle
          x = Math::cos(a)
          y = Math::sin(a)
          d = Geom::Vector3d.new([x, y, 0])
          d.normalize
        }
        return directions
      end

      def get_transformation(eye, up, target)
        return get_coord_transformation(eye, up, target)
      end
      
      
      def get_coord_transformation(eye, up, target)
        xyz = build_xyz_coordinate_system(eye, up, target)
        uvw = build_uvw_coordinate_system(eye, up, target)
        
        case @plane.downcase
        when "xy", "yx"
          transf = Geom::Transformation.new(xyz.origin, xyz.xaxis, xyz.yaxis).inverse
        when "yz", "zy"
          transf = Geom::Transformation.new(xyz.origin, xyz.yaxis, xyz.zaxis).inverse
        when "xz", "zx"
          transf = Geom::Transformation.new(xyz.origin, xyz.zaxis, xyz.xaxis).inverse
        when "uv", "vu"
          transf = Geom::Transformation.new(uvw.origin, uvw.xaxis, uvw.yaxis).inverse
        when "vw", "wv"
          transf = Geom::Transformation.new(uvw.origin, uvw.yaxis, uvw.zaxis).inverse
        when "wu", "uw"
          transf = Geom::Transformation.new(uvw.origin, uvw.zaxis, uvw.xaxis).inverse
        else 
          raise "unkown directions"
        end
        return transf.inverse
      end

    end # CPlaneDirectionGenerator

    class CRegularDirectionsGeneratorOnPlane < CDirectionsGeneratorOnPlane  
    end
   
    class CRandomDirectionsGeneratorOnPlane  < CDirectionsGeneratorOnPlane
      
      def get_transformation(eye, up, target)
        # coordinate transform
        transf  = get_coord_transformation(eye, up, target)
        
        # random rotation
        angle   = rand() * 2 * Math::PI
        puts angle
        rotation = Geom::Transformation.rotation([0, 0, 0], [0, 0, 1], angle)
        
        return transf * rotation
      end
    end
    

    class CDirectionsGeneratorInSpace < CDirectionsGenerator
      def initialize(options={})
        defaults = {"number" => 12}
        options =  defaults.merge(options)
        @ndirections = options["ndirections"]
      end

      def get_canonical_directions()
      
        case @ndirections
        when 4
          ds = NPLAB::ShootScriptGenerator.get_tetrahedron_centers()
        when 6
          ds =  NPLAB::ShootScriptGenerator.get_cube_centers()
        when 8
          ds = NPLAB::ShootScriptGenerator.get_cube_vetices()
        when 12
          ds = NPLAB::ShootScriptGenerator.get_dodecahedron_centers()
        when 20
          ds = NPLAB::ShootScriptGenerator.get_dodecahedron_vetices()
        else
          raise "unsupported directions numbers"
        end
        
        directions = ds.collect{|d| Geom::Vector3d.new(d)}
        
        return directions
      end
    

      def get_transformation(eye, up, target)
        return  build_uvw_coordinate_system(eye, up, target).inverse
      end
  
    end
  
    class CRegularDirectionsGeneratorInSpace < CDirectionsGeneratorInSpace  
    end
    
    class CRandomDirectionsGeneratorInSpace < CDirectionsGeneratorInSpace
      def get_transformation(eye, up, target)
        transform = build_uvw_coordinate_system(eye, up, target).inverse
        xaxis = Geom::Vector3d.new([1, 0, 0])
        yaxis = Geom::Vector3d.new([0, 1, 0])
        zaxis = Geom::Vector3d.new([0, 0, 1])
    
        theta = 2 * Math::PI * rand()
        phi   = 2 * Math::PI * rand()
    
        transform1 = Geom::Transformation.rotation([0, 0, 0], xaxis, theta)
        transform2 = Geom::Transformation.rotation([0, 0, 0], zaxis, phi)
        transf = transform * transform2 * transform1
        return transf
      end
    end
    
  
    class CSpecialDirectionsGenerator < CDirectionsGenerator
      def initialize(options={})
        defaults = {"directions" =>["left"]}
        options =  defaults.merge(options)
        @directions = options["directions"]
      end
      
      def generate_directions(eye, up, target)
        xyz = build_xyz_coordinate_system(eye, up, target)
        uvw = build_uvw_coordinate_system(eye, up, target)
        
        vdirections = @directions.collect{ |direction|
          case direction.downcase
          when Array
            Geom::Vector3d.new(direction).normalize
          when "right", "v"
            uvw.yaxis
          when "left", "-v"
            uvw.yaxis.reverse
          when "up", "u"
            uvw.xaxis
          when "down", "-u"
            uvw.xaxis.reverse
          when "forward", "w"
            uvw.zaxis
          when "backward", "-w"
            uvw.zaxis.reverse
          when "x"
            xyz.xaxis
          when "-x"
            xyz.xaxis.reverse
          when "y"
            xyz.yaxis
          when "-y"
            xyz.yaxis.reverse
          when "z"
            xyz.zaxis
          when "-z"
            xyz.zaxis.reverse
          else
            raise "unkonw special direction"
          end
        }
        return vdirections
        
      end
    end #end CSpecificDirectionsGenerator
    
  end
 
end 