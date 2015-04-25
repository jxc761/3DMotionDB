module NPLAB
	module CTS_EXT
		def self.merge_cts_files(input, output_dir, recursively=false)
	
			filenames = inputs
			if File.directory?(input)
				# print input arguments
				puts("Input		  : #{input_dir}")
				puts("Output	  : #{output_dir}")
				puts("?Recursively: #{recursively}")

				# list all files
				pattern = File.join(root_dir, "*.cts.json")
				if recursively 
					pattern = File.join(root_dir, "**", "*.cts.json")
				end
				filenames = Dir.glob(pattern)
			end
	
	
	
			# group files
			dicts = Hash.new() 
			filenames.each{ |fn|
				puts("fn")
		
				prefix = fn.sub(/(_\d*)?\.cts\.json$/, "")
				group = dicts.key(prefix)
				unless group
					group = []
				end
				group	<< fn
				dicts[prefix] = group
			}
	
			# process group by group
			dicts.each{ |key, group|
				cameras = []
				targets = []
				paris = []
		
				group.each{ |fn|
					cur_cts = NPLAB::CoreIO::CCameraTargetSetting.from_json(fn)
					cameras << cur_cts.cameras
					targets << cur_cts.targets
					paris	  << cur_cts.paris
				}
				
				# output_file_name
				cts = NPLAB::CoreIO::CCameraTargetSetting.new(cameras, targets, pairs)
				fout = key.sub(input_dir, output_dir) + ".cts.json"
				cts.save(fout)
			}
		end

		def self.relabel_cts_files(src_dir, dst_dir, recursively=false)
			pattern = File.join(root_dir, "*.cts.json")
			if recursively 
				pattern = File.join(root_dir, "**", "*.cts.json")
			end
			filenames = Dir.glob(pattern)
			filenames.each{ |src_file|
				dst_file = key.sub(src_dir, dst_dir)
				relabel_cts_file(src_file, dst_file)
			}
		end

		def self.relabel_cts_file(src_file, dst_file)
				src_cts = NPLAB::CoreIO::CCameraTargetSetting.from_json(src_file)
				dst_cts = relabel(src_cts)
				dst_cts.save(dst_file)
		end

    def self.relabel_cts(cts)
      cameras0 = cts.cameras # old
      targets0 = cts.targets # old 
      pairs0   = cts.pairs     # old
  
      cmap = Hash.new()
      cameras = []
      cameras0.each_index{ |i|
        cur = cameras0[i]
        oldId = cur.id
        newId = i.to_s
        cmap[oldId] = newId
        cameras << NPLAB::CoreIO::CInstance.new(newId, cur.position)
      }
 
      tmap = Hash.new()
      targets = []
      targets0.each_index{ |i|

        cur = targets0[i]
        oldId = cur.id
        newId = i.to_s
        tmap[oldId] = newId
    
        targets << NPLAB::CoreIO::CInstance.new(newId, cur.position)
      }
  
  
      pairs = pairs0.collect{|pair|
        cid = cmap[pair.camera_id]
        tid = tmap[pair.target_id]
        NPLAB::CoreIO::CPair.new(cid, tid)
      }
  
      return  NPLAB::CoreIO::CCameraTargetSetting.new(cameras, targets, pairs)
    end


		def self.export_previews_for_cts(fn_cts, dn_output, width = 512, height = 512, fov=nil)
	
			model = Sketchup.active_model
			view  = Sketchup.active_model.active_view
	
	
			cts  	=  NPLAB::CoreIO::CCameraTargetSetting.from_json(fn_cts)
			pairs = cts.paris

			model.start_operation("export previews")
	
			if fov
				view.camera.fov=fov
			end
	
			pairs.each{ |pair|
		
				cid = pair.camera_id
				tid = pair.target_id
		
				camera = cts.get_camera(cid)
				target = cts.get_target(tid)
		
				eye  	=  camera.location
				up    = camera.up
				focus = target.location
		
				view.camera.set(eye, focus, up)
		
				fn_img = File.join(dn_output, "#{cid}_#{tid}.png")
		
				view.write_image(fn_img, width, height)
			}
	
			model.abort_operation

		end


		def self.create_pages_for_cts(fn_cts)
	
			cts  	=  NPLAB::CoreIO::CCameraTargetSetting.from_json(fn_cts)
	
			model = Sketchup.active_model
			pages	= Sketchup.active_model.pages
	
			cameras = cts.cameras # NPLAB.camera_annotation_to_json(model)
			targets = cts.targets # NPLAB.target_annotation_to_json(model)
			pairs   = cts.pairs
	
			# create a page for each pairr
			pairs.each{|pair|
				camera = cts.get_camera(pair.camera_id)
				target = cts.get_target(pair.target_id)
				eye = camera.location
				up = camera.up
				focus = target.location
	
				sceneName = "#{camera.id}_#{target.id}"
	
				page =pages.add(sceneName)
				page.camera.set(eye, focus, up)
				page.update(1) #1, Camera Location, 2, Hidden Geometry,
			}
	
		end

		def self.open_cts_dialog()
			model 		= Sketchup.active_model
			directory = File.dirname(model.path)
			basename  = File.basename(model.path, ".skp" )
			return UI.openpanel("Open cts", directory,  basename + ".cts.json")
		end
		
		def self.save_cts_dialog()
			model 		= Sketchup.active_model
			directory = File.dirname(model.path)
			basename  = File.basename(model.path, ".skp" )
			return UI.savepanel("Save cts", directory,  basename + ".cts.json")
		end
		
		
		def self.input_output_options(prompts, defaults, list)
			dn_input 	= UI.select_directory(title: "Select Input Directory")
			unless dn_input
				return nil
			end
	
	
			dn_output = UI.select_directory(title: "Select Output Directory")
			unless dn_output
				return nil
			end
	
			options 		= UI.inputbox(prompts, defaults, list, "options")
			unless options
				return nil
			end
			
			return {"input"=>dn_input, "output"=>output, "options" => options}
		end
		
		
		def self.ui_relabel_files()
			inputs = input_output_options(["explore subfolders?"], ["yes"], ["yes|no"])
			src_dir = inputs["input"]
			dst_dir = inputs["output"]
			flag  = inputs["options"][0]
			relabel_cts_files(src_dir, dst_dir, flag)
		end
		
		
		
		def ui_relabel_file()
			src_file = open_cts_dialog()
			dst_file = save_cts_dialog()
			relabel_cts_files(src_file, dst_file)
		end
		
		def self.ui_merge_and_relabel()
			inputs = input_output_options(["explore subfolders?"], ["yes"], ["yes|no"])
			src_dir = inputs["input"]
			dst_dir = inputs["output"]
			flag  = inputs["options"][0]
			
			merge_cts_files(src_dir, dst_dir, flag)
			relabel_cts_files(dst_dir, dst_dir, flag)
		end
		
		
		def self.ui_export_previews_for_cts()
			model 		= Sketchup.active_model
			directory = File.dirname(model.path)
			basename 	= File.basename(model.path, ".skp" ) 
		
			fn_cts 		= model.path.sub("/\.skp$/", ".cts.json")
			dn_output = model.path.sub("/\.skp$/", "")
	
			inputs = UI.inputbox(["Input:", "Output:", "width", "height", "fov"], [fn_cts, dn_output, 512, 512, 45], "Set output directory")
			unless inputs
				return
			end
	
			fn_cts = inputs[0]
			dn_output = input[1]
			width = input[2]
			height = input[3]
			fov = input[4]
	
			unless File.directory?(dn_output)
				system("mkdir -r #{dn_output}")
			end
	
			export_previews_for_cts(fn_cts, dn_output, width, height , fov)
		end

		def self.ui_create_pages_for_cts()
			fn_cts = open_cts_dialog()
			unless fn_cts
				return
			end
	
			create_pages_for_cts(fn_cts)
		end




		def self.ui_merge_cts_files()
			inputs = input_output_options(["explore subfolders?"], ["yes"], ["yes|no"])
			dn_input = inputs["input"]
			dn_output = inputs["output"]
			flag  = inputs["options"][0]
			
			merge_cts_files(dn_input, dn_output, flag)
		end
	
		menu = UI.menu("Tools").add_submenu("process cts files")
		menu.add_item("Merge serveral"){
			ui_merge_cts_files()
		}

		menu.add_item("Relabel file"){
			ui_relabel_file()
		}
		
		menu.add_item("Relabel files") {
			ui_relabel_files()
		}
		
		menu.add_item("Merge&Relabel") {
			ui_merge_and_relabel()
		}
		
		menu.add_separator
		menu.add_item("Create Pages for NPLAB cameras") {

			model = Sketchup.active_model
			view  = Sketchup.active_model.view
			pages = Sketchup.active_model.pages


			definition = model.definitions[NPLAB::CN_CAMERA]
			return unless definition 

			instances = definition.instances
			return unless instances


			instances.each{ |camera|

				up = NPLAB.get_camera_up(camera)
				eye = NPLAB.get_camera_location(camera)
				target = view.guess_target

				id = NPLAB.get_id(camera)

				pages.add ""

			}
		}

		menu.add_item("Relabel Current Annotation"){

		}

		menu.add_item("Export preview"){
			ui_export_previews_for_cts()
		}

		menu.add_item("Create pages"){
			ui_create_pages_for_cts()
		}
		

	
	end
	
end

file_loaded( __FILE__ )
