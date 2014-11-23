module NPLAB
  module ShootScriptGenerator
    
    class CDirectionsGenerator
      def initialize(options={})
        raise "Interface"
      end
    
      def generate_directions(coordinate_system)
        transf = get_transformation(coordinate_system)
        ds = get_canonical_directions().collect{ |direction|
          direction.transform(transf)
        }
        return ds
      end
    
      def get_transformation(coordinate_system)
        raise "Interface"
      end
    
      def get_canonical_directions()
        raise "Interface"
      end
  
    end
  
  
  
    class CDirectionsGeneratorOnPlane < CDirectionsGenerator
      def initialize(options={})
        defaults = {"ndirections" => 8, "plane" => "zx"}
        options =  defaults.merge(options)
      
        @ndirections =  options["ndirections"]
    
        hash={"u"=>"x", "v" => "y", "w"=> "z"}
        @plane  = options["plane"].gsub(/u|v|w/){|m| hash[m]}
    
        @canonical_directions  = CDirectionsGeneratorOnPlane.get_directions_on_plane(@ndirections)
      end
    
      def get_canonical_directions()
        @canonical_directions
      end
    
      def get_transformation(coordinate_system)
        angle   = rand() * 2 * Math::PI
        roation = Geom::Transformation.rotation([0, 0, 0], [0, 0, 1], angle)
        transf  = get_coord_transformation(coordinate_system)
        return transf * rotation
      end
    
      def get_coord_transformation(coordinate_system)
        cs = coordinate_system
        origin = coordinate_system.origin
        case @plane
        when "xy", "yx"
          transf = Geom::Transformation.new(origin, cs.xaxis, cs.yaxis )
        when "yz", "zy"
          transf = Geom::Transformation.new(origin, cs.yaxis, cs.zaxis )
        when "xz", "zx"
          transf = Geom::Transformation.new(origin, cs.zaxis, cs.xaxis )
        else 
          raise "unkown directions"
        end
        return transf
      end


      def self.get_directions_on_plane(nDirections)
        d_rad = 2 * Math::PI / nDirections
    
        directions = (0...nDirections).collect{ |ni|
          a = d_rad * ni  # angle
          x = Math::cos(a)
          y = Math::sin(a)
          d = [x, y, 0]
          d.normalize
        }
        return directions
      end
  
    end # CPlaneDirectionGenerator
  
  
  
    class CRegularDirectionsGeneratorOnPlane < CDirectionsGeneratorOnPlane
      def get_transformation(coordinate_system)
        return get_coord_transformation(coordinate_system)
      end
  
    end
   

    class CDirectionsGeneratorInSpace < CDirectionsGenerator
      def initialize(options={})
        defaults = {"number" => 12}
        options =  defaults.merge(options)
        @ndirections = options["ndirections"]
        @canonical_directions   = CDirectionsGeneratorInSpace.get_directions_in_space(@ndirections)
      end

      def get_canonical_directions()
        @canonical_directions
      end
    

      def get_transformation(coordinate_system)
        xaxis = Geom::Vector3d.new([1, 0, 0])
        yaxis = Geom::Vector3d.new([0, 1, 0])
        zaxis = Geom::Vector3d.new([0, 0, 1])
    
        theta = 2 * Math::PI * rand()
        phi   = 2 * Math::PI * rand()
    
        transform1 = Geom::Transformation.rotation([0, 0, 0], xaxis, theta)
        transform2 = Geom::Transformation.rotation([0, 0, 0], zaxis, phi)
        transf = coordinate_system * transform2 * transform1
        return transf
      end
      
      
      def self.get_directions_in_space(nDirections)
        case nDirections
        when 4
          directions = NPLAB::ShootScriptGenerator.get_tetrahedron_centers()
        when 6
          directions = NPLAB::ShootScriptGenerator.get_cube_centers()
        when 8
          directions = NPLAB::ShootScriptGenerator.get_cube_vetices()
        when 12
          directions = NPLAB::ShootScriptGenerator.get_dodecahedron_centers()
        when 20
          directions = NPLAB::ShootScriptGenerator.get_dodecahedron_vetices()
        else
          raise "unsupported directions numbers"
        end
    
        return directions
  
      end
    
  
    end
  
    class CRegularDirectionsGeneratorInSpace < CDirectionsGeneratorInSpace
      def get_transformation(coordinate_system)
        return coordinate_system
      end
    
    end

  
    class CSpecificDirectionsGenerator < CDirectionsGenerator
      def initialize(options={})
        defaults = {"directions" =>["left"]}
        options =  defaults.merge(options)
        @canonical_directions  = get_special_directions(options["directions"])
      end
    
      def get_canonical_directions()
        @canonical_directions
      end
    
      def get_transformation(coordinate_system)
        return coordinate_system
      end
      
    
      def get_special_directions(directions)

        origin= Geom::Point3d.new(0, 0, 0)
        uaxis = Geom::Vector3d.new([1, 0, 0])
        vaxis = Geom::Vector3d.new([0, 1, 0])
        waxis = Geom::Vector3d.new([0, 0, 1])
        coord = Geom::Transformation.new(uaxis, vaxis, waxis, origin)
    
        vdirections = directions.collect{ |direction|
          case direction
          when Array
            Geom::Vector3d.new(direction).normalize
          when "left"
            Geom::Vector3d.new([0, 1, 0])
          when "right"
            Geom::Vector3d.new([0, -1, 0])
          when "up"
            Geom::Vector3d.new([0, 0, 1])
          when "down"
            Geom::Vector3d.new([0, 0, -1])
          when "forward"
            Geom::Vector3d.new([1, 0, 0])
          when "backward"
            Geom::Vector3d.new([-1, 0, 0])
          else
            raise "unkonw special direction"
          end
        }
        return vdirections
      
      end # get_special_directions
=begin    
      def get_special_directions(directions)

        origin= Geom::Point3d.new(0, 0, 0)
        uaxis = Geom::Vector3d.new([1, 0, 0])
        vaxis = Geom::Vector3d.new([0, 1, 0])
        waxis = Geom::Vector3d.new([0, 0, 1])
        coord = Geom::Transformation.new(uaxis, vaxis, waxis, origin)
    
        vdirections = directions.collect{ |direction|
          case direction
          when Array
            direction.transform(coord).normalize
          when "left"
            uaxis
          when "right"
            origin-uaxis
          when "up"
            vaxis
          when "down"
            origin - vaxis
          when "forward"
            orign - waxis
          when "backward"
            waxis
          else
            raise "unkonw special direction"
          end
        }
        return vdirections
      
      end # get_special_directions
=end
    end #end CSpecificDirectionsGenerator
    
  end
 
end 