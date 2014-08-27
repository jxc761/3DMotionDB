

def run_file(fn_ruby, args)
  #temp_parameters
  fn_tmp = File.join(File.dirname(fn_ruby), "parameters.txt")
  file =  File.open(fn_tmp, "w")
  args.each{|a|
    file.puts a
  }
  file.close
  
  app_name  = '"' + '/Applications/SketchUp 2013/SketchUp.app' + '"'
  cmd       = "open --wait-apps " + app_name + " --args -RubyStartup " + '"' + fn_ruby + '"'
  system(cmd)
  
end

def print_usage
  cmd_name = File.basename(__FILE__)
  puts "Usage:"
  puts "  #{cmd_name} <fn_studio>   <dn_objects>  <fn_output>       <nobjects>"
  puts "  #{cmd_name} <fn_studio>   <dn_objects>  <dn_output>       <nscenes>           <nobjects>"
  puts "  #{cmd_name} <dn_studio>   <dn_objects>  <dn_output>       <nscenes>           <nobjects>"
end


def is_cmd_1(args) 
  return File.file?(ARGV[0]) && ARGV[3].match(/^\d+$/) == nil
end

def cmd_1(args)
  fn_ruby  = File.absolute_path(File.dirname(__FILE__)) + "/su_assemble_object_scenes.rb"
  self.run_file(fn_ruby, args)
end

def is_cmd2(args)
  return File.file?(ARGV[0]) && ARGV[3].match(/^\d+$/) != nil
end




def assemble_with_one_studio(args)
  %x("rm -r #{dn_output}")
  %x("mkdir #{dn_output}")
  
  studio_name = File.basename(args[0])
  fn_studio   = args[0]
  dn_objects  = args[1]
  dn_output   = args[2]
  nscenes     = args[3].to_i
  nobjects    = args[4]
   
  
  (0...nscenes).each{ |s|
    # prameter for one-time run
    fn_output_skp = File.join(dn_output, "#{studio_name}_#{s}.skp")
    fn_spots_info = File.join(dn_output, "#{studio_name}_#{s}.spot.json")
    args1 = [fn_studio, dn_]
  }
end

#-------------------------------------------------------------------------------------
if ARGV.size < 4
  print_usage
  exit
end

fn_ruby  = File.absolute_path(File.dirname(__FILE__)) + "/su_assemble_object_scenes.rb"

# {cmd_name} <fn_studio>  <dn_objects>  <fn_output> <nobjects>
if ARGV.size==4
  
  File.file?(ARGV[0]) & ARGV[3].match(/^\d+$/) == nil
  run_file(fn_ruby, ARGV)
  exit()
end

#{cmd_name} <fn_studio>   <dn_objects>  <dn_output>       <nscenes>           <nobjects>"
#{cmd_name} <dn_studio>   <dn_objects>  <dn_output>       <nscenes>           <nobjects>"
# parameters
if File.file?(ARGV[0])
  fn_studios = [ARGV[0]]
else
  fn_studios = Dir[File.join(ARGV[0], "*.skp")]
end

dn_objects  = ARGV[1]
dn_output   = ARGV[2]
nscenes     = ARGV[3].to_i
nobjects    = ARGV[4].to_i

fn_studios.each{ |fn_studio|
  studio_name = File.basename(fn_studio).sub(/.skp$/, "")
  
  (0...nscenes).each{ |s|
    # prameter for one-time run
    fn_output_skp = File.join(dn_output, "#{studio_name}_#{s}.skp")
    fn_spots_info = File.join(dn_output, "#{stuido_name}_#{s}.spot.json")
    args = [fn_studio, dn_objects, fn_output_skp, fn_spots_info, nobjects]
    self.run_file(fn_ruby, args)
  }
}


