NPLAB_3DMOTION_PROJECT_PATH = File.dirname(File.dirname(__FILE__))
#UI.messagebox("Hello: #{NPLAB_3DMOTION_PROJECT_PATH}")


require "#{NPLAB_3DMOTION_PROJECT_PATH}/src/core.rb"
require "#{NPLAB_3DMOTION_PROJECT_PATH}/src/annotation_tool.rb"

require "#{NPLAB_3DMOTION_PROJECT_PATH}/src/assembler.rb"
require "#{NPLAB_3DMOTION_PROJECT_PATH}/src/autofocus.rb"

require "#{NPLAB_3DMOTION_PROJECT_PATH}/src/shoot_script_generator.rb"
require "#{NPLAB_3DMOTION_PROJECT_PATH}/src/shoot_script_validation.rb"

require "#{NPLAB_3DMOTION_PROJECT_PATH}/src/render.rb"
