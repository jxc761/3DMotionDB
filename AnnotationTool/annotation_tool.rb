require "#{File.dirname(__FILE__)}/annotation/annotation_ui.rb"

require "#{File.dirname(__FILE__)}/annotation/movement/movement.rb"

module NPLAB_UI
  #Sketchup.send_action("showRubyPanel:")

  cmd_reset= UI::Command.new("Reset Annotation") {
    ui_reset_tool_status()
    Sketchup.active_model.select_tool(nil)
  }

  cmd_reset.small_icon = "./annotation/icons/reset_16.png"
  cmd_reset.large_icon = "./annotation/icons/reset_24.png"
  cmd_reset.menu_text = "Reset Annotation"
  cmd_reset.tooltip = "Reset Annotation"

  cmd_camera = UI::Command.new("setup camera") {
    Sketchup.active_model.select_tool(CCameraTool.new)
  }
  cmd_camera.small_icon = "./annotation/icons/add_camera_16.png"
  cmd_camera.large_icon = "./annotation/icons/add_camera_24.png"
  cmd_camera.menu_text = "setup camera"
  cmd_camera.tooltip = "setup observer"

  cmd_add_target = UI::Command.new("add target") {
    Sketchup.active_model.select_tool(CTargetTool.new)
  }
  cmd_add_target.small_icon = "./annotation/icons/add_target_16.png"
  cmd_add_target.large_icon = "./annotation/icons/add_target_24.png"
  cmd_add_target.menu_text = "add a target"
  cmd_add_target.tooltip = "add an target"
  cmd_add_target.status_bar_text = "Double click"

  cmd_save_setting_as= UI::Command.new("save setting as") {
    ui_save_setting_as()
  }
  cmd_save_setting_as.small_icon = "./annotation/icons/save_setting_as_16.png"
  cmd_save_setting_as.large_icon = "./annotation/icons/save_setting_as_24.png"
  cmd_save_setting_as.menu_text = "save setting as"
  cmd_save_setting_as.tooltip = "save setting as"

  cmd_save_setting= UI::Command.new("save setting") {
    ui_save_setting()
  }

  cmd_save_setting.small_icon = "./annotation/icons/save_setting_16.png"
  cmd_save_setting.large_icon = "./annotation/icons/save_setting_24.png"
  cmd_save_setting.set_validation_proc{ ui_save_setting_validation() }
  cmd_save_setting.menu_text = "Save setting"
  cmd_save_setting.tooltip = "Save setting to default path"

  annotation_toolbar = UI::Toolbar.new("annotation")
  annotation_toolbar.add_item(cmd_reset)
  annotation_toolbar.add_item(cmd_camera)
  annotation_toolbar.add_item(cmd_add_target)
  annotation_toolbar.add_item(cmd_save_setting)
  annotation_toolbar.add_item(cmd_save_setting_as)
  if annotation_toolbar.get_last_state == 1
  annotation_toolbar.show
  end

  UI.add_context_menu_handler do |context_menu|
    item = context_menu.add_item("Flip Camera") {
      NPLAB_UI.ui_flip_camera()
    }
    context_menu.set_validation_proc(item){NPLAB_UI.ui_flip_camera_validation}
  end

end

file_loaded( __FILE__ )
