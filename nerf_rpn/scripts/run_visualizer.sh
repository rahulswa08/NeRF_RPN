set -x
set -e

DATA_ROOT=../../data/front3d_rpn_data

BOX_FORMAT=obb


python3 -u visualize_rpn_input.py \
--output_dir ${DATA_ROOT}/output \
--feature_dir ${DATA_ROOT}/features \
--box_dir ${DATA_ROOT}/obb \
--box_format ${BOX_FORMAT} \

