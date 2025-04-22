#!/bin/bash

if [[ -n "$SLEEP" ]]; then
    sleep 86400
fi

# Default percentages
W_PCT="${W_PCT:-0.95}"
N_PCT="${N_PCT:-0.30}"

CPU_COUNT="$(nproc)"

# Calculate thread numbers (rounded down explicitly)
if [[ -z "$W_THREADS" ]]; then
    W_THREADS=$(printf "%.0f" $(echo "$CPU_COUNT * $W_PCT" | bc -l))
fi

if [[ -z "$N_THREADS" ]]; then
    N_THREADS=$(printf "%.0f" $(echo "$CPU_COUNT * $N_PCT" | bc -l))
fi

# Ensure at least one worker thread if percentage is nonzero
(( W_THREADS == 0 )) && W_THREADS=1

TIMEOUT="${TIMEOUT:-45}"
RUNTIME=$((TIMEOUT - 5))

echo "running with $W_THREADS workload and $N_THREADS noise threads"

# Run noise threads if N_THREADS > 0
if (( N_THREADS > 0 )); then
    sysbench cpu --threads=$N_THREADS --time=$RUNTIME run &
fi

# Run main workload
schbench -t "$W_THREADS" -r "$RUNTIME"

