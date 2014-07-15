#!/bin/bash


echo "begin install......"


# get this root directory 
# 
ORG_PWD=$PWD                                          #record the origin working directory
ME=$(dirname "$0")                                    #this script directory
ROOT_DIR=$(cd "$(dirname "$ME")"; pwd)                #the root directory
cd $ORG_PWD                                           #go back the origin working directory


# the content to be written
FILE_CONTENT="require '$ROOT_DIR/su_include/nplab_plugins.rb'"


# the sketchup plugin driectory
SU_PLUGIN_DIR="$HOME/Library/Application Support/SketchUp 2013/SketchUp/Plugins"

# the file to be created
TARGET_FILE="${SU_PLUGIN_DIR}/nplab.rb"

# write the content to the file
echo $FILE_CONTENT > $TARGET_FILE


# print message
echo "New file: ${TARGET_FILE}"
echo "Please restart sketchup to use the plugins."
echo "finish install......."
