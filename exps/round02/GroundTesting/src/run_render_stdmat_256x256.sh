#!/bin/bash

ROOT_DIR="${HOME}/GroundTesting"
MXS_DIRNAME="StandardMatScene_buffer_256x256" 
MXS_DIR="${ROOT_DIR}/${MXS_DIRNAME}"
OUTPUT_DIR="${ROOT_DIR}/${MXS_DIRNAME}_output"

NUM_NODES=6
SL_START=12
SL_STEP=2
SL_STOP=22
RES="256x256"
PROJNAME="teststdmat_${SL_START}_${SL_STOP}_${RES}"
echo "${MXS_DIR}" 
echo "${OUTPUT_DIR}" 
echo ${NUM_NODES} 
echo ${SL_START}
echo ${SL_TEP} 
echo ${RES}

./multi_batch_render.sh "${MXS_DIR}" "${OUTPUT_DIR}" ${NUM_NODES} ${SL_START} ${SL_STEP} ${SL_STOP} ${RES} ${PROJNAME}
