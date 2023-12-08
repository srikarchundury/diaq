rm -rf cpu_build
mkdir cpu_build
cd cpu_build
cmake ..
make -j 4
cd ..
