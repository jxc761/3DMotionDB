#!/bin/sh 

current_dir=$(pwd)
script_dir=$(dirname $0)
if [ $script_dir = '.' ]
then
script_dir="$current_dir"
fi
root_dir=$script_dir
project_dir=$(dirname $(dirname $root_dir))


fn_shoot_script_configuration="${root_dir}/confs/shoot_script.conf.json"
dn_camera_target_setting="${root_dir}/cts"
dn_root_outputs="${root_dir}/shoot_scripts"



rm -r "${dn_root_outputs}"
mkdir -p "${dn_root_outputs}"


fn_ruby="${project_dir}/cli/generate_shoot_scripts/cmd_generate_shoot_scripts.rb"
ruby "${fn_ruby}" "${fn_shoot_script_configuration}" "${dn_camera_target_setting}" "${dn_root_outputs}"



fn_ruby="${project_dir}/cli/validate_shoot_scripts/cmd_validate_shoot_scripts.rb"

dn_skps="${root_dir}/skps"
dn_scripts="${root_dir}/shoot_scripts/config_0"
dn_outputs="${root_dir}/valid_shoot_scripts/config_0"

rm -r "${dn_outputs}"
mkdir -p "${dn_outputs}"

ruby "${fn_ruby}" "${dn_skps}" "${dn_scripts}" "${dn_outputs}"