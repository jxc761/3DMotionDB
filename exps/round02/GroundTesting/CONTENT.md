
Update: July 3, 2015

=======
Content
=======


./res
|-- Arroway Textures - Edition One.pdf : document for "Arroway Textures ""
|-- materials_edition-1_maxwell_mxm.rar : Ready-to-use material setups for MaxwellRender™ 2.x from arroway textures
|-- StandardMatScene 06-29	: standard material testing scene from maxwell render
|-- Arroway Textures - Edition One : arroway textures


./input: 
|-- mxm	:	Candidate materials. 
|   |    	All are from Arroway Textures Edition 1. The scales of texture maps have been changed to the real size.
|	|-- textures:	Textures from Arroway Textures Edition 1. 
|				  	The file names have been changed to match the reference name in mxm(maxwell material file). 
|--	test01  : A normal object-level outside scene. 
|
|--	StandardMatScene : The standard material testing secene. The filename of textures have been fixed
|
|-- trace	: camera motion trace
|-- sample_seqs 	:  a subset of mxs sequences  

./sdk : maxwell render C++ SDK

./src : souce code
	
	+ Basic render tools

		* batch_render.sh
		* render_thread.sh

		* mutli_batch_render.sh
		* multi_render_thread.sh
	
		Note: there are some custom texture paths in render_thread.sh and multi_render_thread.sh.


	+ render differenent sets of mxs:
		* run_render_fixed.sh 	    : test01_800x600_sl[12-22]	
		* run_render_stdmat_256x256 : stdmat_256x256_sl[12-22]	
		* run_render_stdmat_64x64   : stdmat_64x64_sl[12-22]	
		* run_render_seqs           : frames_64x64_sl(16/18)
		* run_render_sample_seqs    : frames_64x64_sl[12-22] 

	+ others
		* fix_texture_scale			: contain the C++ script to fix texture scale in mxm files
		* proprocess_textures.py 	: change the texture file names to match the references in mxm file
		* apply_mxm_to_test01.py 	: the script that apply each material to gound in test01 
		* apply_mxm_to_stdmat.py 	: the script that add each materials to StandardMatScene
		* generate_frames.py 		: generate a seqences of mxs files based on camera trace
		* draft.sh  				: shell commands that to organize files or extract information
        * prepare_sample_seqs.sh    : prepare inputs for batch rendering sample sequences




./results: expriment results



	