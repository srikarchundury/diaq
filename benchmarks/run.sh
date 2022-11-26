#scl enable devtoolset-8

source /opt/rh/devtoolset-8/enable .
g++ -o bench benchmarks.cpp -Itool/include -Ltool -lcnpy -lz --std=c++11
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/tool/