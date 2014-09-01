#!/bin/sh 
 

current_dir=$(pwd)
script_dir=$(dirname $0)
if [ $script_dir = '.' ]
then
  script_dir="$current_dir"
fi
root_dir=$(dirname $script_dir)
 
 
dn_inputs="${root_dir}/skps"
dn_outputs="${root_dir}/cts"
number=3

rm -r "${dn_outputs}"
mkdir -p "${dn_outputs}"

project_dir=$(dirname $root_dir)
fn_ruby="$project_dir/cli/autofocus/cmd_autofocus.rb"

ruby "${fn_ruby}" "${dn_inputs}" "${dn_outputs}" ${number}