ROOT_DIR="${HOME}/GroundTesting"

MXS_DIR="${ROOT_DIR}/frames"
SL=18
OUTPUT_DIR="${ROOT_DIR}/frames$SL"

NUM_NODES=10
PROJNAME=${4-render} #optional
RES="64x64"

echo "${MXS_DIR}" 
echo "${OUTPUT_DIR}" 
echo ${NUM_NODES} 
echo ${SL} 
echo ${RES}
batch_render.sh "${MXS_DIR}" "${OUTPUT_DIR}" ${NUM_NODES} ${SL} ${RES}
