require "#{File.dirname(__FILE__)}/core.rb"
require "#{File.dirname(__FILE__)}/annotation_tool/annotation_ui.rb"

#require "#{File.dirname(__FILE__)}/annotation/movement/movement.rb"

module NPLAB
  
  view_menu=UI.menu "View"
  view_menu.add_separator
  sub_menu = view_menu.add_submenu("FOV Animation")
  
  start_zoom = sub_menu.add_item("Start FOV Animation") {
    Sketchup.active_model.active_view.animation = CFOVAnimator.new
  }
  
  
  end_zoom = sub_menu.add_item("End Fov Animation") {
    Sketchup.active_model.active_view.animation = nil
  }
  #Sketchup.send_action("showRubyPanel:")

  #---------------------------------------------------
  # clear annotation
  #---------------------------------------------------
  cmd_clear_annotation = UI::Command.new("clear annotation") {
    ui_clear_annoation()
    
  }
  
  cmd_clear_annotation.small_icon = "./annotation_tool/icons/clear_annotation_16.png"
  cmd_clear_annotation.large_icon = "./annotation_tool/icons/clear_annotation_24.png"
  cmd_clear_annotation.menu_text  = "clear annotation"
  cmd_clear_annotation.tooltip    = "clear annotation"

  #---------------------------------------------------
  # set camera
  #---------------------------------------------------
  cmd_camera = UI::Command.new("setup the camera") {
    Sketchup.active_model.select_tool(CCameraTool.new)
  }
  
  cmd_camera.small_icon = "./annotation_tool/icons/add_camera_16.png"
  cmd_camera.large_icon = "./annotation_tool/icons/add_camera_24.png"
  cmd_camera.menu_text  = "set the camera"
  cmd_camera.tooltip    = "set the camera"
  cmd_camera.status_bar_text = "double click"
  
  #---------------------------------------------------
  # add target
  #---------------------------------------------------
  cmd_add_target = UI::Command.new("add a target") {
    
    if NPLAB.get_camera_number() !=1
			UI.messagebox("The number of camera must be 1.")
			Sketchup.active_model.select_tool(nil)
    else
      Sketchup.active_model.select_tool(CTargetTool.new)
    end
  }
 
  cmd_add_target.small_icon = "./annotation_tool/icons/add_target_16.png"
  cmd_add_target.large_icon = "./annotation_tool/icons/add_target_24.png"
  cmd_add_target.menu_text = "add a target"
  cmd_add_target.tooltip = "add a target"

  #-------------------------------------------------
  # save setting
  #-------------------------------------------------
  cmd_save_setting= UI::Command.new("save setting") {
    ui_save_setting()
    
  }
  
 # cmd_save_setting.set_validation_proc{ 
#    ui_save_setting_validation() 
#  }
  cmd_save_setting.small_icon = "./annotation_tool/icons/save_json_16.png"
  cmd_save_setting.large_icon = "./annotation_tool/icons/save_json_24.png"
  cmd_save_setting.menu_text = "save setting to the default file"
  
  
  
  #----------------------------------------------------
  # load setting in
  #----------------------------------------------------
  cmd_load = UI::Command.new("load in the setting from a file") {
      ui_load_setting()
      
  }
  cmd_load.small_icon = "./annotation_tool/icons/load_setting_16.png"
  cmd_load.large_icon = "./annotation_tool/icons/load_setting_24.png"
  cmd_load.menu_text = "load setting"
  cmd_load.tooltip = "load setting"
  
  
  #---------------------------------------------------
  # save setting as
  #---------------------------------------------------
  cmd_save_setting_as= UI::Command.new("save setting as") {
    ui_save_setting_as()
    
  }
  #cmd_save_setting_as.set_validation_proc{ ui_save_setting_validation() }
  
  cmd_save_setting_as.small_icon  = "./annotation_tool/icons/save_setting_as_16.png"
  cmd_save_setting_as.large_icon  = "./annotation_tool/icons/save_setting_as_24.png"
  cmd_save_setting_as.menu_text   = "save setting as"
  cmd_save_setting_as.tooltip     = "save setting as"
  
  
  
  #---------------------------------------------------
  # show or hide
  #---------------------------------------------------
  
  cmd_show_setting = UI::Command.new("show setting") {
    ui_show_setting()
    
  }
    
  cmd_show_setting.small_icon  = "./annotation_tool/icons/show_16.png"
  cmd_show_setting.large_icon  = "./annotation_tool/icons/show_24.png"
  cmd_show_setting.menu_text   = "show setting"
  cmd_show_setting.tooltip     = "show setting"
  
  
  cmd_hide_setting = UI::Command.new("hide setting") {
    ui_hide_setting()
    
  }
    
  cmd_hide_setting.small_icon  = "./annotation_tool/icons/hide_16.png"
  cmd_hide_setting.large_icon  = "./annotation_tool/icons/hide_24.png"
  cmd_hide_setting.menu_text   = "hide setting"
  cmd_hide_setting.tooltip     = "hide setting"
  
  
  cmd_show_setting_info= UI::Command.new("show setting info") {
    ui_show_setting_info()
    
  }
    
  cmd_show_setting_info.small_icon  = "./annotation_tool/icons/info_16.png"
  cmd_show_setting_info.large_icon  = "./annotation_tool/icons/info_24.png"
  cmd_show_setting_info.menu_text   = "show setting info"
  cmd_show_setting_info.tooltip     = "show setting info"
  
  
  
  annotation_toolbar = UI::Toolbar.new("Annotation")
  
 
  annotation_toolbar.add_item(cmd_load)
  
  annotation_toolbar.add_separator
  
  annotation_toolbar.add_item(cmd_clear_annotation)
  annotation_toolbar.add_item(cmd_camera)
  annotation_toolbar.add_item(cmd_add_target)
  annotation_toolbar.add_item(cmd_save_setting)
  
  annotation_toolbar.add_separator
  annotation_toolbar.add_item(cmd_save_setting_as)
  
  annotation_toolbar.add_separator
  annotation_toolbar.add_item(cmd_show_setting)
  annotation_toolbar.add_item(cmd_hide_setting)
  annotation_toolbar.add_item(cmd_show_setting_info)
  
 
  if annotation_toolbar.get_last_state == 1
     annotation_toolbar.show
  end

  UI.add_context_menu_handler do |context_menu|
    item = context_menu.add_item("Flip Camera") {
      NPLAB.ui_flip_camera()
    }
    context_menu.set_validation_proc(item){ ui_flip_camera_validation }
  end

end

file_loaded( __FILE__ )
