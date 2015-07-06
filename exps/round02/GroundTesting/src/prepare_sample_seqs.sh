#!/bin/bash

ROOT_DIR="${HOME}/GroundTesting" 
#rm ../sample_seqs/*/*/*.mxi
#rm ../sample_seqs/*/*/*.png


#copy files
SRC_DIR="${ROOT_DIR}/sample_seqs"
BUFFER_DIR="${ROOT_DIR}/sample_seqs_buffer"
for SL in $(seq 12 2 22 )
do
	DST_DIR="${BUFFER_DIR}/sl${SL}"
	if [ ! -d "${DST_DIR}" ]
	then
		mkdir -p "${DST_DIR}"
	fi

	for SCENE_NAME in $(ls -1 "${SRC_DIR}")
	do
		echo  "src: ${SRC_DIR}/${SCENE_NAME}/1_0_0_0"
		echo  "dst: ${DST_DIR}/${SCENE_NAME}_sl${SL}"
		cp -r "${SRC_DIR}/${SCENE_NAME}/1_0_0_0" "${DST_DIR}/${SCENE_NAME}_sl${SL}"
	done
done


