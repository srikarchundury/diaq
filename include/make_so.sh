g++ -c -fPIC qSparse.cpp -o libqSparse.o
g++ -shared -Wl,-soname,libqSparse.so -o libqSparse.so libqSparse.o