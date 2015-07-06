#!/bin/bash

ROOT_INPUT_DIR="${HOME}/GroundTesting/StandardMatScene_buffer_64x64"
ROOT_OUTPUT_DIR="${HOME}/GroundTesting/StandardMatScene_buffer_64x64_output"


MXS_DIRNAME="sample_seqs" 
MXS_DIR="${ROOT_DIR}/${MXS_DIRNAME}"
OUTPUT_DIR="${ROOT_DIR}/${MXS_DIRNAME}_output"


SLs=(12 14 16 18 20 22)
NODEs=(1  1  1 2   2  3)
RES="64x64"

for i in $( seq 0 5)
do
	SL=${SLs[$i]}
	NUM_NODES=${NODEs[$i]}

	MXS_DIR="${ROOT_INPUT_DIR}/sl${SL}"
	OUTPUT_DIR="${ROOT_OUTPUT_DIR}/sl${SL}"
	PROJNAME="teststdmat_$SL"

	echo "${MXS_DIR}" 
	echo "${OUTPUT_DIR}" 
	echo "${NUM_NODES}" 
	echo "${SL}" 
	echo "${RES}"
	echo "${PROJNAME}"

	./batch_render.sh "${MXS_DIR}" "${OUTPUT_DIR}" ${NUM_NODES} ${SL} ${RES} ${PROJNAME}
done

