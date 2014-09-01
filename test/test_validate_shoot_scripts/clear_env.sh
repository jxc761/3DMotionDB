#!/bin/sh 

current_dir=$(pwd)
script_dir=$(dirname $0)
if [ $script_dir = '.' ]
then
script_dir="$current_dir"
fi
root_dir=$script_dir

rm -r "$root_dir/shoot_scripts"
rm -r "$root_dir/valid_shoot_scripts"


