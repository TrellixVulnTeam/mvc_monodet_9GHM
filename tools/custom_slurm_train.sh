#!/usr/bin/env bash

set -x
PARTITION=$1
JOB_NAME=$2
CONFIG=$3
GPUS=${GPUS:-$4}
GPUS_PER_NODE=${GPUS_PER_NODE:-$4}
CPUS_PER_TASK=${CPUS_PER_TASK:-5}
PORT=`expr $RANDOM % 40000 + 1000`
echo "port: $PORT"
SRUN_ARGS=${SRUN_ARGS:-""}
PY_ARGS=${@:5}

PYTHONPATH="$(dirname $0)/..":$PYTHONPATH \
srun -p ${PARTITION} \
    --job-name=${JOB_NAME} \
    --gres=gpu:${GPUS_PER_NODE} \
    --ntasks=${GPUS} \
    --ntasks-per-node=${GPUS_PER_NODE} \
    --cpus-per-task=${CPUS_PER_TASK} \
    --kill-on-bad-exit=1 \
    --quotatype=reserved \
    ${SRUN_ARGS} \
    python -Xfaulthandler -u tools/train.py ${CONFIG}  --launcher="slurm" ${PY_ARGS}