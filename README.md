#3DMotionDB
==========

Generate a motion dataset based on 3D models

##Install the plugin
====================
###For MAC:
  Run the script install_su_plugins.sh
  
###For windows:
  - Step 1: Find out where is the sketchup plugin driectory
    - Start SketchUp
    - Copy and paste the following line to the SketchUp Ruby Console
    
            Sketchup.find_support_file("Plugins")
      
  - Step 2: Find the path of the file
  	
  		./su_include/nplab_plugins.rb
  		   
    Let <path_to_plugins> be this path.
    
  - Step 3: New a ruby file under the sketchup plugin driectory, for example, "nplab.rb"

  - Step 4: Add one line content to the "nplab.rb" file
    
        require "<path_to_plugins>"
    
   