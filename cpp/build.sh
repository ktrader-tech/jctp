rm -rf build
cmake CMakeLists.txt -B build
cmake --build build --config Release
cp build/lib/libjctp.so ../lib
