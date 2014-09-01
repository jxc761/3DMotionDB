#!/bin/bash

echo "begin install......"
# Step 1
# Set SU_PLUGIN_DIR to the sketchup plugin driectory
# Here is a sure-fire way to find out where is the sketchup plugin driectory
#  1. Start SketchUp
#  2. Copy and paste the following line to the SketchUp Ruby Console
#     Sketchup.find_support_file("Plugins")
#
SU_PLUGIN_DIR="$HOME/Library/Application Support/SketchUp 2013/SketchUp/Plugins"


# the file to be created
TARGET_FILE="${SU_PLUGIN_DIR}/nplab.rb"
rm "${TARGET_FILE}"

# Find the file locatation of nplab_plugins.rb which should be under the folder  
#      project_root_dir/su_include/
#

# get the project root directory
current_dir=$(pwd)
script_dir=$(dirname $0)
if [ $script_dir = '.' ]
then
script_dir="$current_dir"
fi
ROOT_DIR=$script_dir

INCLUDE_FILE="${ROOT_DIR}/su_include/nplab_plugins.rb"


# Sketchup.find_support_file("Plugins")
# the content to be written
FILE_CONTENT="require \"${INCLUDE_FILE}\""


# write the content to the file
echo ${FILE_CONTENT} > "${TARGET_FILE}"


# print message
echo "New a file: ${TARGET_FILE}"
echo "Please restart sketchup to use the plugins."
echo "finish install......."
