rmdir /s/q build
cmake CMakeLists.txt -B build
cmake --build build --config Release
copy build\lib\Release\jctp.dll ..\lib