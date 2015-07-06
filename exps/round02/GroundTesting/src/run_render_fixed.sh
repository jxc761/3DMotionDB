#!/bin/bash

ROOT_DIR="${HOME}/GroundTesting"

INPUT_NAME="fixed"
MXS_DIR="${ROOT_DIR}/${INPUT_NAME}"
SL=16
OUTPUT_DIR="${ROOT_DIR}/${INPUT_NAME}_sl$SL_output"

NUM_NODES=10
RES="800x600"
PROJNAME="${INPUT_NAME}_$SL_${RES}"

echo "${MXS_DIR}" 
echo "${OUTPUT_DIR}" 
echo "${NUM_NODES}" 
echo "${SL}" 
echo "${RES}"
echo "${PROJNAME}"
./batch_render.sh "${MXS_DIR}" "${OUTPUT_DIR}" ${NUM_NODES} ${SL} ${RES} ${PROJNAME}
