module NPLAB
  module ShootScriptGenerator
    

    def self.generate_shoot_scripts11(fn_conf, fn_cts, dn_output)
      confs = CShootScriptGenerationConfs.load(fn_conf).confs
      generator = build_shoot_script_generator(confs[0])
      
      cts = NPLAB::CoreIO::CCameraTargetSetting.load(fn_cts)
      
      gen_ss_for_one_cts(generator, cts, dn_output)
    end


    def self.generate_shoot_scripts(fn_conf, dn_cts, dn_outputs)


      confs = CShootScriptGenerationConfs.load(fn_conf).confs
      cts_files = Dir[File.join(dn_cts, "*.cts.json")]

      confs.each_index{ |cid|
        # the directory for this configuration
        sub_output_dir = File.join(dn_outputs, "config_#{cid}")
        system("mkdir #{sub_output_dir}")
 
        
        # build the generator according to the configuration
        generator = build_shoot_script_generator(confs[cid])
      
        # generate the shootscript for cts one by one
        cts_files.each{ |fn_cts|
          
          # set the output path for current cts 
          name = File.basename(fn_cts).sub(/\.cts\.json$/, "")
          cur_output_dir = File.join(sub_output_dir, name)
          system("mkdir #{cur_output_dir}")
          cts = NPLAB::CoreIO::CCameraTargetSetting.load(fn_cts)
          gen_ss_for_one_cts(generator, cts, cur_output_dir)
        }
      }

  
    end

    
    def self.gen_ss_for_one_cts(generator, cts, dn_output)
      pairs = cts.get_pairs()
      
      pairs.each{|pair|
        camera  = pair[0]
        target  = pair[1]
        
        scripts = generator.generate_shoot_scripts(camera, target)
  
        scripts.each_index{ |direction_index|
     
          sub_scripts = scripts[direction_index]
     
          sub_scripts.each_index{ |speed_index|
            script = sub_scripts[speed_index]
            
            fn = "#{camera.id}_#{target.id}_#{direction_index}_#{speed_index}.ss.json"
       
            script.save(File.join(dn_output, fn))  
          } 
        }
   
      }
     
    end
  
  end
end