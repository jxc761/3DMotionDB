module NPLAB
  module XML
    
    
    # XML element
    # Usage:
    #
    # Note: 
    # - attribute "text" vs method "org_str"
    # 
    #   The attribute "text" refers to the text in the xml file, 
    #   while the method "org_str" refers to the real string. 
    #   The difference between them results from special characters
    #   in xml. For example, if the text is "&lt;&gt;&amp;&apos;&quot;" 
    #   the org_str must be "<>&'\""
    #
    class CBaseElement
      attr_accessor :children, :name, :text, :parent

      # 
      # the argument "is_text" is to specify the argument "text" is  
      def initialize(name="", text="", children=[], parent=nil, is_text = true)
        @name     = name
        @text     = is_text ? text : str_to_text(text)
        @children = children
        @parent   = parent
      end 
  
      def org_str
        text_to_str(@text)
      end
    
      def org_str=(s)
        @text=str_to_text(s)
      end
    
          
      def add_sub_element(elem)
        children.push(elem)
        elem.parent = self
        return elem
      end
  
      def leaf?
        return @children.empty?
      end
  
      # Get all elements whose tag is "name".
      # Arg: 
      # - name: the tag name
      # - is_recursive: whether search recursively. Default value is false.
      #
      # Return:
      #   An array of elements with tag "name"
      # 
      # Note:
      #   - If there is no element under self, it will return []
      #   - If is_recursive is true, then it will get all elements with tag "name".
      #   - If is_recursive is false, it will just get the top elements with tag "name".
      #   For example, Let the element as following:
      #     <group>
      #       <name>LargeGroup<name>
      #       <member>Alex</member>
      #       <group>
      #            <name>Subgroup<name>
      #            <member>Jone</member>
      #       </group>
      #     </group>    
      #   While get_elements(group, true) will return two elements, LargeGroup and Subgroup,
      #   get_elements(group, false) will just return one element, LargeGroup.
      # 
      def get_elements(name, is_recursive=false)
        
        elems =  @name==name ? [self] : []

        if leaf? || (is_recursive==false && @name==name)
           return elems
        end        
  
        @children.each{|child|
          elems.concat(child.get_elements(name, is_recursive)) 
        }
  
        return elems
      end
      
      
      def get_leafs()
        if leaf?
          return [self]
        end
  
        leafs = []
        @children.each{|child|
          leafs.concat(child.get_leafs)
        }
  
        return leafs
      end
  
      # The string of current elements
      #
      # if keep_text == false, it will keep the origin string
      # else, it will subtitute the special character with the entity
      # 
      # 
      def to_s(indent=0, keep_text = false)
  
        text= keep_text ? @text : org_str
        s = " " * indent + "<#{@name}>#{text}"
      
        unless leaf?
          str_children = ""
          @children.each{|child|
          str_children << child.to_s(indent+2, keep_text)
          }
          s << "\r\n" << str_children << " " * indent
        end
    
        s << "</#{@name}>\r\n"
  
        return s
      end # end to_s
      
      
      # Convert current string to hash
      #
      def to_hash()
        if leaf?
          return valueOftext()
        end  
        
        h = {"#{@name}_text" => valueOftext()}
        children.each{ |child|
          value = child.to_hash()
          name  = child.name()
         
          if h.has_key?(name)
            h[name] = [ h[name] ]unless h[name].kind_of?(Array)
            h[name] <<  value
          else
            h[name] = value
          end
        }
         
        return h
        
      end # end to hash
      
      
      private
           
      # private methods for special characters processing
      def text_to_str(text)
        s= String.new(text)
        s.gsub!("&lt;", '<')
        s.gsub!("&gt;",'>')
        s.gsub!("&apos;", "'")
        s.gsub!("&quot;", '"')
        s.gsub!("&amp;",'&')
        return s
      end


      def str_to_text(s)
        t = String.new(s)
        t.gsub!("&", "&amp;")
        t.gsub!("<", "&lt;")
        t.gsub!(">", "&gt;")
        t.gsub!("'", "&apos;")
        t.gsub!('"', "&quot;")
        return t
      end
  
        
      
      def valueOftext()
        value = ""
        begin
          value = eval(org_str)
        rescue
          value = org_str
        end
        
        return value
      end
  
    end #end class
    
    
   
  end
end