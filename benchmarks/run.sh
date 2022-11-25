#scl enable devtoolset-8

source /opt/rh/devtoolset-8/enable .
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/tool/
g++ -o bench benchmarks.cpp -Itool/include -Ltool -lcnpy -lz --std=c++11
