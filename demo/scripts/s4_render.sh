#!/bin/sh 

current_dir=$(pwd)
script_dir=$(dirname $0)
if [ $script_dir = '.' ]
then
script_dir="$current_dir"
fi
root_dir=$(dirname $script_dir)


fn_render_conf="${root_dir}/confs/su_render.conf.json"
dn_skps="${root_dir}/skps"
dn_root_scripts="${root_dir}/shoot_scripts/config_0"
dn_root_outputs="${root_dir}/images/config_0"

rm -r "${dn_root_outputs}"
mkdir  -p "${dn_root_outputs}"

project_dir=$(dirname $root_dir)
fn_ruby="${project_dir}/cli/render/cmd_render.rb"
ruby "${fn_ruby}" "${fn_render_conf}" "${dn_skps}" "${dn_root_scripts}" "${dn_root_outputs}"
