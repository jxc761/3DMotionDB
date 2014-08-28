 self.build_shoot_script_generator(conf)
 
 confs = CoreIO.CShootScriptGenerationConfs.load(conf)
 confs.each{ |conf|

 }
 
 generator = ShootScript.build_shoot_script_generator(conf)
 scripts.generate_shoot_scripts(camera, target)
 CCameraTargetSetting.load(camera_target_setting)
 validation
 