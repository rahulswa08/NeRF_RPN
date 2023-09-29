set -x
set -e

NERF_ROOT=../../data/front3d_nerf_data
DATA_ROOT=../../data/front3d_rpn_data

BOX_FORMAT=obb


python3 -u render_heatmap.py \
--dataset_dir ${NERF_ROOT} \
--feature_dir ${DATA_ROOT}/features \
--proposal_dir ${DATA_ROOT}/proposals \
--boxes_dir ${DATA_ROOT}/obb \
--output_dir ${DATA_ROOT}/output_heat \
# --box_format ${BOX_FORMAT} \

