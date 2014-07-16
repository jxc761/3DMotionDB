# UI.messagebox("Hello, I am NPLAB_plugin")


NPLAB_3DMOTION_PROJECT_PATH = File.dirname(File.dirname(__FILE__))
UI.messagebox("Hello: #{NPLAB_3DMOTION_PROJECT_PATH}")
require "#{NPLAB_3DMOTION_PROJECT_PATH}/AnnotationTool/annotation_tool.rb"
