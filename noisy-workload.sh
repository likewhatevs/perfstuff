#!/bin/bash

if [[ -n "$SLEEP" ]]; then
    sleep 86400
fi

CPU_COUNT="$(nproc)"

# fallback if not provided
W_PCT="${W_PCT:-}"
N_PCT="${N_PCT:-}"

if [[ -z "$W_PCT" ]]; then
    W_PCT="0.95"
fi
if [[ -z "$N_PCT" ]]; then
    N_PCT="0.30"
fi

# DEBUG output
echo "DEBUG: W_PCT=$W_PCT"
echo "DEBUG: N_PCT=$N_PCT"
echo "DEBUG: CPU_COUNT=$CPU_COUNT"

# Calculate thread numbers (rounded down)
if [[ -z "$W_THREADS" ]]; then
    W_THREADS=$(printf "%.0f" "$(echo "$CPU_COUNT * $W_PCT" | bc -l)")
fi

if [[ -z "$N_THREADS" ]]; then
    N_THREADS=$(printf "%.0f" "$(echo "$CPU_COUNT * $N_PCT" | bc -l)")
fi

# Ensure at least one worker thread if W_THREADS is nonzero
(( W_THREADS == 0 )) && W_THREADS=1

TIMEOUT="${TIMEOUT:-45}"
RUNTIME=$((TIMEOUT - 5))

echo "running with $W_THREADS workload and $N_THREADS noise threads"

