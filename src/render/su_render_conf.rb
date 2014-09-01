module NPLAB
  module Render
    class CSURenderConf < NPLAB::BasicJson::CJsonObject
      # camera related parameters
      # px, px, mm, degree
      #
      attr_accessor :image_width, :image_height, :film_width, :fov, :render_options, :shadow_info
       
      def aspect_ratio 
        @image_width * 1.0 / @image_height
      end
      
      
      def initialize(iw, ih, fw, fov, ro, si)
        @image_width    = iw
        @image_height   = ih
        @film_width     = fw
        @fov            = fov
        @render_options = ro
        @shadow_info    = si
      end
      
      def to_json()
        json = {
          "image_width"     => @image_width,
          "image_height"    => @image_height,
          "film_width"      => @film_width,
          "fov"             => @fov,
          "render_options"  => @render_options,
          "shadow_info"     => @shadow_info
        }
        return json
      end
      
      def self.from_json(json)
        j = self.default_conf.merge(json)     
        return self.new(j["image_width"], j["image_height"], j["film_width"], j["fov"], j["render_options"], j["shadow_info"])
      end
    
      def self.default_conf
        fn_default_conf = "#{File.dirname(__FILE__)}/default_su_render.conf.json"
        return BasicJson.load(fn_default_conf)
      end
      
    end
    
  end
end