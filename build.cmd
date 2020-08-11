chcp 65001
cd swig
call build.cmd
cd ..\cpp
call build.cmd
cd ..\java
gradlew jar