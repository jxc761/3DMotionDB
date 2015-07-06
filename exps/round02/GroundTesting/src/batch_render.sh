#!/bin/bash

# batch_render.sh
# 
# usage:
# ./batch_render.sh MXS_DIR OUTPUT_DIR NUM_NODES [PROJECT_NAME]
# 
# This script finds all the .mxs files in MXS_DIR, renders all of them with
# Maxwell Renderer using as many cluster jobs as it can without exceeding
# NUM_NODES, and outputs the resulting png images to OUTPUT_DIR with the same
# names, plus diagnostic output and error log files.

set -o nounset
set -o errexit

# parameters
MXS_DIR=$1
OUTPUT_DIR=$2
NUM_NODES=$3
SL=$4
RES=$5 
PROJNAME=${6-render} #optional



if [ ! -d ./logs ]
then
  mkdir -p ./logs
fi

if [ ! -d "${OUTPUT_DIR}/logs" ]
then
  mkdir -p "${OUTPUT_DIR}/logs"
fi



# global variables
THREAD_NUM=0

# function initializes temp file that lists MXS file paths
InitMXSFileList () {
  MXS_FILE_LIST_PATH=$(mktemp ./logs/tmp_batch_render.XXXXXXXXXX) || { echo "Failed to create temp file"; exit 1; }
  NUM_MXS_FILES_LISTED=0
}

# function adds the parameter to the MXS file path list
AddToMXSFileList () {
  echo $1 >> $MXS_FILE_LIST_PATH
  NUM_MXS_FILES_LISTED=$((NUM_MXS_FILES_LISTED+1))
}

# function starts a job to render the current list of files using Maxwell,
# clears the list and increments the thread number
StartRenderJob () {
  THREAD_NUM=$((THREAD_NUM+1))
  echo "Starting thread $THREAD_NUM with $NUM_MXS_FILES_LISTED files"
  qsub -N "${PROJNAME}_thread_${THREAD_NUM}"  -l walltime=96:00:00 \
    -l nodes=1:ppn=12,mem=10gb \
    -o "${OUTPUT_DIR}/logs/${PROJNAME}_thread_${THREAD_NUM}_output.txt" \
    -e "${OUTPUT_DIR}/logs/${PROJNAME}_thread_${THREAD_NUM}_error.txt" \
    -v MXS_FILE_LIST_PATH=${MXS_FILE_LIST_PATH},OUTPUT_DIR=${OUTPUT_DIR},SL=${SL},MXS_DIR=${MXS_DIR},RES=${RES} \
    ./render_thread.sh
}

# init log
echo "Running batch_render.sh"
echo "Started $(date +%F\ %T)"

# calculated constants
NUM_MXS_FILES=$( find "${MXS_DIR}" -maxdepth 5 -name "*.mxs" | wc -l )
NUM_MXS_FILES_PER_NODE=$(((NUM_MXS_FILES + (NUM_NODES-1))/NUM_NODES))

# log info
echo "MXS_DIR = $MXS_DIR"
echo "OUTPUT_DIR = $OUTPUT_DIR"
echo "NUM_NODES = $NUM_NODES"
echo "PROJNAME = $PROJNAME"
echo "NUM_MXS_FILES = $NUM_MXS_FILES"
echo "NUM_MXS_FILES_PER_NODE = $NUM_MXS_FILES_PER_NODE"

InitMXSFileList

# create output directory if necessary
if [ ! -d ${OUTPUT_DIR} ]
then
  mkdir -p ${OUTPUT_DIR}
fi

# iterate over each mxs file
for MXS_PATH in $( find "${MXS_DIR}" -maxdepth 5 -name "*.mxs")
do 
  echo ${MXS_PATH} 

  AddToMXSFileList ${MXS_PATH}

  if [ $NUM_MXS_FILES_LISTED -eq $NUM_MXS_FILES_PER_NODE ]
  then
    StartRenderJob
    InitMXSFileList
  fi
done

# final job for leftover files
if [ $NUM_MXS_FILES_LISTED -gt 0 ]
then
  StartRenderJob
else
  rm ${MXS_FILE_LIST_PATH}
fi

echo "Ended $(date +%F\ %T)"
