#!/usr/bin/ruby

##Project:  None
##Author:  Erick Cantwell
##Email:  erick@erickcantwell.com
##Written:  January 2011
##
##This is a very simple method for parsing a Unix style configuration file
##and returning their values in a hash
##
## Description:
## This module has a simple method for parsing Unix Style Configuration file.
## 
## Unix Style Configuration:
## 		* the line starts with '#' is a comment line
##		* the blank line is allowed
##		* each line has only one configuration parameter
##      * a parameter is given by the "name=value" pair
##		* the leading and trail white spaces will be stripped for both "name" and "value"
##      *    
##		MConfig.get_vars(filenmae)
## 
## Author: Jing Chen
## Email : jxc761@case.edu
## Date  : June 29, 2014
## 
## Simple Configuration File Reading With Ruby. Erick Cantwell. 2011. 
## http://www.erickcantwell.com/2011/01/simple-configuration-file-reading-with-ruby/
## 
##

module CLIUtil

	def self.get_vars(conf_fn, required=nil)
		# check the existence of file
		unless File.exists?(conf_fn) then
			raise "Error: File doesn't exist!\r\n#{conf_fn}\r\n"
		end
		
		vars = Hash.new
		
		# parse the file line by line
		IO.foreach(conf_fn) do |line|
			# Strip the white spaces  
			line=line.strip
			
			if line.match(/^#/)    # Discard the comment line 
				next
			elsif line.match(/^$/) # Discard the blank line
				next	
			else
				# Parse the parameters
				parts = line.split("=", 2)
				vars[parts[0].strip] = parts[1].strip
			end
		end
		
		# check whether all required parameters exist
		unless required.nil? then
			required.each{ |key|
				raise "Error:A required parameter doesn't exist!\r\n#{key}" unless vars.has_key?(key)
			}
		end	
		
		return vars
	end
  
  def self.run_file(fn_ruby, args)
    #temp_parameters
    fn_tmp= File.join(File.dirname(fn_ruby), "parameters.txt")
    file=File.open(fn_tmp, "w")
    args.each{|a| file.puts a}
    file.close
    
    
    #app_name  = '"' + '/Applications/SketchUp 2013/SketchUp.app' + '"'
    #cmd       = "open --wait-apps " + app_name + " --args -RubyStartup " + '"' + fn_ruby + '"'
    #puts cmd
    #system(cmd)
    
    # find sketchup
    apps  = Dir.glob('/Applications/*/Sketchup.app')
    if apps.length < 1
      puts("Cannot find sketchup!")
      exit()
    end

    apps.sort!
    
    # run sketchup

    app_name  = '"' + apps[-1] + '"'
    # app_name  = '"' + '/Applications/SketchUp 2014/SketchUp.app' + '"'
    cmd       = "open --wait-apps " + app_name + " --args -RubyStartup " + '"' + fn_ruby + '"'
    puts(cmd)
    system(cmd)
    
  end
  

  def exit_su
    if Sketchup.version_number > 15000000 
      Sketchup.quit
    else
      exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")
    end 
  end

  
  def self.parse_args(required, real_args)
    
    args = {}
    
    if real_args[0].downcase.eql?("-c")  
      
      args = self.get_vars(real_args[1], required)
      
    elsif real_args.size == required.size  
      (0...required.size).each{|i| 
        key   = required[i]
        value = real_args[i]
        args[key] = value
      }
    else
      args = nil
    end
    
    return args
    
  end
  
end


