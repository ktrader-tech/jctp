set -v
cd swig
./build.sh
cd ../cpp
./build.sh
cd ../java
./gradlew jar