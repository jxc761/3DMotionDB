
## this file just contain some once time commands that I used to orginaze render results or find information

grep nplab::log ./frames18/*_output.txt  | cut -d: -f6 > frames_18_times.txt
grep nplab::log ./frames18/*_output.txt  | cut -d: -f12 | cut -d/ -f7,8,9 > frames_18_files.txt

grep nplab::log ./pngs_fixed_material_sl16_res800x600/*_output.txt  | cut -d: -f6 > ./render_time/pngs_fixed_material_sl16_res800x600.txt
grep nplab::log ./pngs_fixed_material_sl16_res800x600/*_output.txt  | cut -d: -f12 | cut -d/ -f6 
#find rendered png
grep nplab::log ./frames16/*_output.txt  | cut -d: -f12 | cut -d/ -f6 > frames_16_files.txt

grep nplab::log ./frames16/*_output.txt  | cut -d: -f12 | cut -d/ -f6 > files.txt


## file copy
ROOT_DIR="${HOME}/GroundTesting"
#SRC_DIR="${ROOT_DIR}/frames18/config_0"
#DST_DIR="${ROOT_DIR}/results/frames_sl18_res64x64"
SRC_DIR="${ROOT_DIR}/frames16/config_0"
DST_DIR="${ROOT_DIR}/results/frames_sl16_res64x64"
#SRC_DIR="/Users/Jing/Dropbox/3DMotion/3DMotionDB/exps/round02/GroundTesting/results/fix_textures/frames16/config_0"
#DST_DIR="/Users/Jing/Dropbox/3DMotion/3DMotionDB/exps/round02/GroundTesting/results/frames_sl16_res64x64"

MOTION_NAMES=("1_0_0_0" "1_0_1_0" "1_0_2_0" "1_0_3_0" "1_0_4_0")
	
for MAT_NAME  in $(ls -1 "${SRC_DIR}")
do
	for i in $(seq 0 4)
	do
		MOTION_NAME="${MOTION_NAMES[$i]}"

		CUR_SRC_DIR="${SRC_DIR}/${MAT_NAME}/${MOTION_NAME}"
		CUR_DST_DIR="${DST_DIR}/${MAT_NAME}_${i}"

		# echo "CUR_SRC_DIR=${CUR_SRC_DIR}"
		# echo "CUR_DST_DIR=${CUR_DST_DIR}"
		if [ ! -d "${CUR_DST_DIR}" ]
		then
			mkdir -p "${CUR_DST_DIR}"
		fi
		
		cp  ${CUR_SRC_DIR}/frame*.png "${CUR_DST_DIR}/" 

	done
	
done  

