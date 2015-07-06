#!/bin/bash
# 
# Designed to be run as a job on a PBS cluster
# 
# Parameters:
#   MXS_FILE_LIST_PATH : the path to the file listing the paths of the MXS files
#   OUTPUT_DIR : the directory of the output images and log files
#   MXS_DIR : the original root directory of the mxs files, useful for recursive renders
#   SL_START:
#   SL_STOP:
#   SL_STEP:
#   RES:
# 
# Outputs the render to a PNG file with the same name as each named MXS file,
# in the output directory. Also outputs maxwell's logging info for each render.

set -o nounset
set -o errexit

cd $PBS_O_WORKDIR

# constants

echo "Running multi_render-thread.pbs"
echo "Started $(date +%F\ %T)"
echo "MXS_FILE_LIST_PATH = $MXS_FILE_LIST_PATH" # the mxs path list file
echo "OUTPUT_DIR = ${OUTPUT_DIR}"  		# the output directory
echo "MXS_DIR = ${MXS_DIR}"
echo "SL_START = ${SL_START}"
echo "SL_STOP = ${SL_STOP}"
echo "SL_STEP = ${SL_STEP}"
echo "RES=${RES}"

# load maxwell
module load maxwell/3.1

# Loop over each .mxs file
while read line
do
	MXS_PATH=$line
	temp=${MXS_PATH##*/}
	MXS_NAME=${temp%.*}
	FULL_MXS_DIR=${MXS_PATH%/*}
	FULL_OUTPUT_DIR=${FULL_MXS_DIR/#$MXS_DIR/$OUTPUT_DIR}

	for SL in $( seq ${SL_START} ${SL_STEP} ${SL_STOP} )
	do
		# create output directory if necessary
		if [ ! -d "${FULL_OUTPUT_DIR}" ]
		then 
			mkdir -p "${FULL_OUTPUT_DIR}"
		fi

		SRC_IMG="${FULL_MXS_DIR}/${MXS_NAME}.png"
		SRC_MXI="${FULL_MXS_DIR}/${MXS_NAME}.mxi"

		DST_IMG="${FULL_OUTPUT_DIR}/${MXS_NAME}_${SL}.png"
		DST_MXI="${FULL_OUTPUT_DIR}/${MXS_NAME}_${SL}.mxi"
		DST_LOG="${FULL_OUTPUT_DIR}/${MXS_NAME}_${SL}.txt"

		# if output image exists, skip
		if [ -f "${DST_IMG}" ]
		then 
			continue
		fi

		# begin to render...
		echo "Rendering $MXS_PATH"
		echo "SRC_IMG = ${SRC_IMG}"
		echo "SRC_MXI = ${SRC_MXI}"
		echo "DST_IMG = ${DST_IMG}"
		echo "DST_MXI = ${DST_MXI}"
		echo "DST_LOG = ${DST_LOG}"


		stime=$(date +%s)

		maxwell -nogui -nowait -trytoresume -res:${RES} -sl:${SL} \
			-mxs:"${MXS_PATH}" -mxi:"${SRC_MXI}" -output:"${SRC_IMG}" \
			-dep:"/usr/local/maxwell-3.0/materials database/textures" \
			-dep:"/home/jxc761/GroundTesting/mxm/textures" \
			-dep:"/home/jxc761/GroundTesting/mxs" > "${DST_LOG}"

	
		cp "${SRC_IMG}" "${DST_IMG}"
		cp "${SRC_MXI}" "${DST_MXI}"
		

		etime=$(date +%s)
		duration=$((etime-stime))
		echo "nplab::log::${duration}::${SL}::${RES}::${MXS_PATH}" 

	done

done < $MXS_FILE_LIST_PATH


rm $MXS_FILE_LIST_PATH
sleep 20
echo "Done $(date +%F\ %T)"
