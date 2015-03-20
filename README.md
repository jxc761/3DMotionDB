#3DMotionDB
-----------

Generate a motion dataset based on 3D models.

<div style="background-color:#E8E8E8; color:#FF00FF; padding:20px; fontsize=14; ">

<p><b>I just test this tool on MAC with Sketchup 2013. But I'd like to make it work on Windows and other SketchUp versions.</b> </p>

</div>


##Install the plugin
--------------------
###For MAC:
  Run the script install_su_plugins.sh
  
###For windows:
  - Step 1: Get the absolute path of this file
  	
  		./su_include/nplab_plugins.rb
  		   
    Let \<path_to_plugins\> be this path.

  - Step 2: Find out where is the sketchup plugin driectory
    - Start SketchUp
    - Copy and paste the following line to the SketchUp Ruby Console
    
            Sketchup.find_support_file("Plugins")
          
  - Step 3: New a ruby file under the sketchup plugin driectory, for example, "nplab.rb"

  - Step 4: Add one line content to the "nplab.rb" file
    
        require "<path_to_plugins>"
    
  
  
##Play with the scripts
-----------------------
1. Go to folder: 
   	
   		./example/scripts

2. Run s1 to s4 step by step

		./s1_assemble.sh	
		./s2_autofocus.sh			
		./s3_generate_shoot_scripts.sh
    	./s4_render.sh

  
##Use the annotation tool
-------------------------
1. Open Sketchup
2. View-> Tool Palettes -> Annotation


## More documents
------------------
[1] https://www.dropbox.com/sh/lxhoy9h7g9pll2x/AAB1v1z2-hmbd66ni6RNUBV4a?dl=0




