#!/bin/bash
build_type=$1
shift  # Remove the first argument (build_type) to pass the remaining as options to run_builds.sh
rm -rf dist/*
rm -rf build/*
rm -rf diaq.egg-info

if [ "$build_type" = "gpu" ]; then
    echo "Building GPU version..."
    ./run_builds.sh gpu "$@"
    CUDA_ENABLED=1 pip install --no-cache-dir .
else
    echo "Building CPU version..."
    ./run_builds.sh cpu "$@"
    pip install --no-cache-dir .
fi
