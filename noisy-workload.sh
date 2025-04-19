#!/bin/bash

W_PCT="${W_PCT:-0.95}"
N_PCT="${N_PCT:-0.30}"
NS_PCT="${NS_PCT:-70}"

CPU_COUNT="$(nproc)"

if [[ -z "$W_THREADS" ]]; then
    W_THREADS=$(printf "%.0f" "$(echo "$CPU_COUNT * $W_PCT" | bc -l)")
fi


if [[ -z "$N_THREADS" ]]; then
    N_THREADS=$(printf "%.0f" "$(echo "$CPU_COUNT * $N_PCT" | bc -l)")
fi

TIMEOUT="${TIMEOUT:-45}"
W_THREADS="${W_THREADS}"
N_THREADS="${N_THREADS}"

echo "running with $W_THREADS workload and $N_THREADS noise"

RUNTIME=$((TIMEOUT - 5))

if awk "BEGIN {exit ($N_THREADS == 0)}"; then
    stress-ng --cpu-method fft -t $RUNTIME -c $N_THREADS -l $NS_PCT &
fi

schbench -t $W_THREADS -r $RUNTIME

