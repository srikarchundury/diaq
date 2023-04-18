rm -rf build/*
rm -rf qsparse.egg-info
CFLAGS="-O3 -fopenmp" pip install --no-cache-dir .
