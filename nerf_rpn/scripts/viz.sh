set -x
set -e

DATA_ROOT=../../data/front3d_nerf_data
RPN_ROOT=../../data/front3d_rpn_data

BOX_FORMAT=obb


python3 -u proposals2ngp.py \
--bbox_format ${BOX_FORMAT} \
--dataset front3d \
--dataset_path ${DATA_ROOT} \
--features_path ${RPN_ROOT}/features \
--proposals_path ${RPN_ROOT}/proposals \
--output_dir ${RPN_ROOT}/nerf_op \

