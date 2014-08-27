#!/usr/bin/env ruby 

  
fn = "#{File.dirname(__FILE__)}/parameters.txt"
puts fn

file = File.open("#{File.dirname(__FILE__)}/parameters.txt", "r")
file = File.open(fn, "r")
fn_skp  = file.readline().strip!
fn_text	= file.readline().strip!
fn_json = file.readline().strip!
file.close


Sketchup.open_file(fn_skp)
NPLAB.load_setting_from_text(Sketchup.active_model, fn_text)
NPLAB.save_setting_to_json(Sketchup.active_model, fn_json)

exec("ps -clx | grep -i 'sketchup' | awk '{print $2}' | head -1 | xargs kill -9")

