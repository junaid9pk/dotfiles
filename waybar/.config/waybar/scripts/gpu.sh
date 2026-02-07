#!/usr/bin/env bash

if command -v nvidia-smi >/dev/null 2>&1; then
    usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
    echo "${usage}"
    exit 0
fi

shopt -s nullglob
for usage_file in /sys/class/drm/card*/device/gpu_busy_percent \
                  /sys/class/drm/card*/device/gt_busy_percent; do
    if [[ -r "${usage_file}" ]]; then
        usage=$(<"${usage_file}")
        echo "${usage}"
        exit 0
    fi
done

# Intel i915 exposes per-engine busy percentages. Some systems expose them
# under connector-specific DRM nodes (e.g., card1-DP-1).
engine_files=(/sys/class/drm/card*/device/engine*/busy_percent /sys/class/drm/card*-*/device/engine*/busy_percent)
if (( ${#engine_files[@]} > 0 )); then
    usage=$(awk '{sum+=$1; n+=1} END {if (n>0) printf "%.0f", sum/n; else print "N/A"}' "${engine_files[@]}")
    echo "${usage}"
    exit 0
fi

# Fallback: approximate load from GT frequency (not true utilization).
cur_files=(/sys/class/drm/card*/device/gt/gt0/rps_cur_freq_mhz /sys/class/drm/card*-*/device/gt/gt0/rps_cur_freq_mhz)
max_files=(/sys/class/drm/card*/device/gt/gt0/rps_max_freq_mhz /sys/class/drm/card*-*/device/gt/gt0/rps_max_freq_mhz)
for cur in "${cur_files[@]}"; do
    if [[ -r "${cur}" ]]; then
        for max in "${max_files[@]}"; do
            if [[ -r "${max}" ]]; then
                cur_val=$(<"${cur}")
                max_val=$(<"${max}")
                if [[ "${cur_val}" =~ ^[0-9]+$ && "${max_val}" =~ ^[0-9]+$ && "${max_val}" -gt 0 ]]; then
                    usage=$(( cur_val * 100 / max_val ))
                    echo "${usage}"
                    exit 0
                fi
            fi
        done
    fi
done

echo "N/A"
