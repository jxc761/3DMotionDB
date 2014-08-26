module NPLAB
  module BasicJson
    
    def self.save(filename, json)
      write_to_json(filename, json)
    end
    
    #------------------------------------------------------------
    # save the internal structure to json file
    #------------------------------------------------------------
    
    #
    # Convert the object to json string and save to the file
    # OBJ must be an instance of array of hash
    #  
    def self.write_to_json(filename, obj)
      
      File.open(filename, 'w') {|f| f.write( to_json(obj)) }
      
    end
    
    
    #
    # Convert the object to json string
    # OBJ must be an instance of array of hash
    # return the string of json
    def self.to_json(obj)
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

  end
  # end module json
  
end