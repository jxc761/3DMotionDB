module NPLAB
  module BasicJson
    
   
    #------------------------------------------------------------
    # save out 
    #------------------------------------------------------------
    def self.save_to_json(obj, filename)
      
      File.open(filename, 'w') {|f| f.write( to_json(obj)) }
      
    end
    
    def to_json(obj)
      case obj
      when Array
        jstr = array_to_json(obj)
      when Hash
        jstr = hash_to_json(obj)
      else
        raise "unsupport data structure"
      end
      return jstr
    end
    
    def self.hash_to_json(h, indent=0)

      jstr = "{ "
      
      h.each{ |key, value|
        jstr  << "\r\n"
        jstr  << " " * (indent+2) + '"' + key + '" : ' +  value_to_json(value, indent+2) + "," 
      }
     
      jstr[-1] = "}" 
      return jstr
    end
    
    def self.array_to_json(array, indent=0)
      astr = "[  "
      array.each{ |value|
        astr << "\r\n" + " " * (indent+2) + value_to_json(value, indent+2) + "," 
      }
      
      astr[-1] = "]"
      return astr
    end
    
    def self.value_to_json(value, indent=0)
      case value
      when Hash
        return hash_to_json(value, indent)
      when Array
        return array_to_json(value, indent)
      when String
        return '"'+ value + '"'
      else
        return value.to_s
      end
    end
   
    
    
    #------------------------------------------------------------
    # load in  
    #------------------------------------------------------------
    def self.parse(input)
      content = File.exist?(input) ? IO.readlines(input).join() : input
      content = content.strip
      
      # this is an object
      case content[0, 1]
      when "{"
        ret, remain = parse_object(content)
      when "["
        ret, remain = parse_array(content)
      else
        raise "json format error"
      end
      
      unless remain.strip.eql?("")
        raise "json format error"
      end
      
      return ret
    end
    

    def self.match_and_strip(content, re)
      match   = content.match(/#{re}/)
      unless match
        raise "json format error!"
      end
      content = match.post_match
      
    end
    
    # parse object 
    def self.parse_object(content)

      # match the begin of the object
      content = match_and_strip(content, /\A\s*\{/)
       

      obj = {}                            # case1: this is an empty object {}
      if content.match(/\A\s*\}/) == nil  # case2 : {members}
        obj, content= parse_members(content)
      end
      
      
      # match the end of the object
      content = match_and_strip(content, /\A\s*\}/)
      
      return obj, content
    end
    
    
    
    #
    #
    def self.parse_array(content)
     
      # match the begin of the array
      content = match_and_strip(content, /\A\s*\[/)
      
    
      array = []                          # case1: this is an empty array[]
      if content.match(/\A\s*\]/) == nil  # case2 : [elements]
        array, content= parse_elements(content)
      end
      
      # match the end of the array
      content = match_and_strip(content, /\A\s*\]/)  
      
      return array, content
    end
    
    
    #
    #
    def self.parse_members(content)
   
      pair, content = parse_pair(content)
      members = pair

      
      match = content.match(/\A\s*,/)
      # if match == nil, members = pair
      # if match != nil, members=  pair, members
      if match
        content = match.post_match
        sub_members, content = parse_members(content)
        members = members.merge(sub_members)
      end

      return members, content       
    end
    
    #
    #
    def self.parse_elements(content)
     
      value, content = parse_value(content)
      elems = [value]
      
      match = content.match(/\A\s*,/)
      # if match == nil, elements = value
      # if match != nil, elements= value, elements
      if match 
        content = match.post_match
        sub_elements, content = parse_elements(content)
        elems.concat(sub_elements)
      end
      

      return elems, content
    end
    
    #
    #
    def self.parse_pair(content)
     
      # get the string part
      attr_name, content = self.parse_string(content)
      
      # match the separator ':'
      content = match_and_strip(content, /\A\s*:/)

      # get the value part
      attr_value, content = self.parse_value(content)
      pair ={ attr_name => attr_value}

      return pair, content
    end
    
    def self.parse_string(content)

      # the beginning of the string
      match = content.match(/\A\s*"/)
      if match == nil
        raise("JSON format error")
      end
      content = match.post_match
      
      # match the end of the match
      match = content.match(/(\A")|([^\\]")/)
      if match == nil
        raise("JSON format error")
      end
      
      string = content[0, match.end(0)-1]
      content = match.post_match

      return string, content
    end
    
    def self.parse_value(content)

       # this is string
       match = content.match(/\A\s*"/)
       if match != nil
         return parse_string(content)
       end
       
       # this is an object
       match = content.match(/\A\s*\{/)
       if match != nil
         return parse_object(content)
       end
       
       # this is an array
       match = content.match(/\A\s\[/)
       if match != nil
         return parse_array(content)
       end
       
       # this is nil
       match = content.match(/\A\s*(null)|(nil)/)
       if match != nil
         value = nil
         content = match.post_match
         return value, content
       end
       
       # this is a number
       re_number = '\A\s*(\-)?(0|([1-9](\d+)?))(\.\d+)?((e|E)(\+|\-)?\d+)?'
       match = content.match(/#{re_number}/)
       if match != nil
         value = eval(match[0].strip)
         content = match.post_match
         return value, content
       end
       
       # this is a boolean value
       match = content.match(/\A\s*((true)|(false))/)
       if match != nil
         value = eval(match[0].strip)
         content = match.post_match        
         return value, content
       end

       # no match
       raise("json format error")
    end 
    # end parse_value

  end
  # end module json
  
end