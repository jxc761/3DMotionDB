#!/bin/sh 

current_dir=$(pwd)
script_dir=$(dirname $0)
if [ $script_dir = '.' ]
then
script_dir="$current_dir"
fi
root_dir=$(dirname $script_dir)


dn_studios="${root_dir}/studios"
dn_objects="${root_dir}/objects"
dn_outputs_skps="${root_dir}/skps"
dn_output_spots="${root_dir}/spots"
dn_output_previews="${root_dir}/previews"
nscenes=20
nobjects=5

rm -r "$dn_outputs_skps"
rm -r "$dn_output_spots"
rm -r "$dn_output_previews"
mkdir -p "$dn_outputs_skps"
mkdir -p "$dn_output_spots"
mkdir -p "$dn_output_previews"

project_dir=$(dirname $root_dir)
fn_ruby="$project_dir/cli/assemble/cmd_assemble.rb"
ruby "${fn_ruby}" "${dn_studios}" "${dn_objects}" "${dn_outputs_skps}" "${dn_output_spots}" "${dn_output_previews}" "${nscenes}" "${nobjects}"
