module NPLAB
  module CoreIO
    class CSURenderConf < NPLAB::BasicJson::CJsonObject
      # camera related parameters
      # px, px, mm, degree
      #
      attr_accessor :image_width, :image_height, :film_width, :fov, :render_options
    
      def aspect_ratio 
        @image_width * 1.0 / @image_height
      end
      
      def initialize(iw, ih, fw, fov, ro)
        @image_width = iw
        @image_height= ih
        @film_width = fw
        @fov = fov
        @render_options = ro
      end
      
      def to_json()
        json = {
          "image_width"     => @image_width,
          "image_height"    => @image_height,
          "film_width"      => @film_width,
          "fov"             => @fov
          "render_options"  => @render_options
        }
        return json
      end
      
      def self.from_json(json)
        return self.new(json["image_width"], json["image_height"], json["film_width"], json["fov"], json["render_options"])
      end
    
    end
    
  end
end