# read in parameters
parameters = ""
file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
args = file.readlines.collect{ |line| line.strip}
file.close


# set parameters
fn_skp = args[0]
dn_mxs = args[1]
fn_mxs = File.join(dn_mxs, "#{File.basename(fn_skp, '.skp')}.mxs")


# open file 
status = Sketchup.open_file(fn_skp)
unless status
    raise "Cannot open file: #{fn_skp}"
end


# make sure the fold exists
if not File.exist?(dn_mxs)
	system('rm -r "' + dn_mxs + '"')
	system('mkdir -p "' + dn_mxs + '"' )
end

status=Sketchup.active_model.export(fn_mxs)
unless status
    UI.messagebox("Cannot export to: #{fn_mxs}")
end

# model = Sketchup.active_model
# old_dn_mxs = MX::Util.get_output_property('output.scene_dir', '') 
# # export
# MX::Util.set_property(model, "output", "output.scene_dir", dn_mxs)
# MX::Export.export('mxs') 
# MX::Util.set_property(model, "output", "output.scene_dir", old_dn_mxs)
# model.save("filename", Sketchup::Model::VERSION_2013)

if Sketchup.version_number > 14000000 
	Sketchup.quit
else
	exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")
end 