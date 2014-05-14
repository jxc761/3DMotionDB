require "#{File.dirname(__FILE__)}/annotation/annotation_ui.rb"

module NPLAB_UI	
	Sketchup.send_action("showRubyPanel:")
	
	cmd_reset= UI::Command.new("Reset Annotation") {
		Sketchup.active_model.select_tool(nil)
		ui_reset_tool_status()
	}
	
	cmd_reset.small_icon = "./annotation/icons/reset_16.png"
	cmd_reset.large_icon = "./annotation/icons/reset_24.png"
	cmd_reset.menu_text = "Reset Annotation"
	cmd_reset.tooltip = "Reset Annotation"
	
	cmd_camera = UI::Command.new("setup camera") {
		Sketchup.active_model.select_tool(CCameraTool.new)
	}
	#cmd_camera.set_validation_proc{CCameraTool.is_valid()}
	cmd_camera.small_icon = "./annotation/icons/add_camera_16.png"
	cmd_camera.large_icon = "./annotation/icons/add_camera_24.png"
	cmd_camera.menu_text = "setup camera"
	cmd_camera.tooltip = "setup observer"

	cmd_add_target = UI::Command.new("add target") {
		Sketchup.active_model.select_tool(CTargetTool.new)
	}
	#cmd_add_target.set_validation_proc{CTargetTool.is_valid()}
	cmd_add_target.small_icon = "./annotation/icons/add_target_16.png"
	cmd_add_target.large_icon = "./annotation/icons/add_target_24.png"
	cmd_add_target.menu_text = "add a target"
	cmd_add_target.tooltip = "add an target"
	cmd_add_target.status_bar_text = "Double click"
	
	cmd_save_setting_as= UI::Command.new("save setting as") {
		Sketchup.active_model.select_tool(nil)
		ui_save_setting_as()
		Sketchup.active_model.active_view.refresh
	}
	cmd_save_setting_as.small_icon = "./annotation/icons/save_setting_as_16.png"
	cmd_save_setting_as.large_icon = "./annotation/icons/save_setting_as_24.png"
	cmd_save_setting_as.menu_text = "save setting as"
	cmd_save_setting_as.tooltip = "save setting as"
	
	annotation_toolbar = UI::Toolbar.new("annotation")
	annotation_toolbar.add_item(cmd_reset)	
    annotation_toolbar.add_item(cmd_camera)
	annotation_toolbar.add_item(cmd_add_target)

	annotation_toolbar.add_item(cmd_save_setting_as)
	
	if annotation_toolbar.get_last_state == 1
		annotation_toolbar.show
	end
	
#	annotation_toolbar.add_item(cmd_look_through)
#	walkman_toolbar.add_item(cmd_export)
end	
#if not file_loaded?(__FILE__)	
#	
#end
file_loaded( __FILE__ )
