#!/bin/sh 

current_dir=$(pwd)
script_dir=$(dirname $0)
if [ $script_dir = '.' ]
then
script_dir="$current_dir"
fi
root_dir=$(dirname $script_dir)


fn_shoot_script_configuration="${root_dir}/confs/shoot_script.conf.json"
dn_camera_target_setting="${root_dir}/cts"
dn_root_outputs="${root_dir}/shoot_scripts"

rm -r "${dn_root_outputs}"
mkdir -p "${dn_root_outputs}"

project_dir=$(dirname $root_dir)
fn_ruby="${project_dir}/cli/generate_shoot_scripts/cmd_generate_shoot_scripts.rb"
ruby "${fn_ruby}" "${fn_shoot_script_configuration}" "${dn_camera_target_setting}" "${dn_root_outputs}"
