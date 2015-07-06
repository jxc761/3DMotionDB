#!/bin/bash

ROOT_INPUT_DIR="${HOME}/GroundTesting/sample_seqs_buffer"
ROOT_OUTPUT_DIR="${HOME}/GroundTesting/sample_seqs_buffer_output"

SLs=(12 14 16 18 20 22)
NODEs=(1  1  1 2   2  3)
RES="64x64"

for i in $( seq 0 5)
do
	SL=${SLs[$i]}
	NUM_NODES=${NODEs[$i]}

	MXS_DIR="${ROOT_INPUT_DIR}/sl${SL}"
	OUTPUT_DIR="${ROOT_OUTPUT_DIR}/sl${SL}"
	PROJNAME="testseq_$SL"

	echo "${MXS_DIR}" 
	echo "${OUTPUT_DIR}" 
	echo "${NUM_NODES}" 
	echo "${SL}" 
	echo "${RES}"
	echo "${PROJNAME}"

	./batch_render.sh "${MXS_DIR}" "${OUTPUT_DIR}" ${NUM_NODES} ${SL} ${RES} ${PROJNAME}
done

