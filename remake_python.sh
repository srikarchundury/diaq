rm -rf build/*
rm -rf diaq.egg-info
CUDA_ENABLED=1 pip install --no-cache-dir .
