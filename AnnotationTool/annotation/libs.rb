
# add libs 
root_dir  = File.dirname(File.dirname(File.dirname(__FILE__)))
tools_dir = "#{root_dir}/tools" 
json_lib  = "#{tools_dir}/base_json/src/basic_json.rb"
array_lib = "#{tools_dir}/array1d/src/array1d.rb"

require "#{json_lib}"
require "#{array_lib}"

require "#{File.dirname(__FILE__)}/test/test_movement.rb"

# UI.messagebox(json_lib)