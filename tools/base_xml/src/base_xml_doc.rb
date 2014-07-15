require "#{File.dirname(__FILE__)}/base_xml_element.rb"

module NPLAB
  module XML
    
    #################################################
    class CBaseDocument
      attr_accessor :root
      def initialize()
        @root=nil
      end
    end
  
  end
end