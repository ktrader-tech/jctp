javaOutputDir=../java/src/main/java/org/rationalityfrontline/jctp
cppOutputDir=../cpp/src
rm -rf $javaOutputDir
mkdir $javaOutputDir
rm ${cppOutputDir}/jctp.cpp
rm ${cppOutputDir}/jctp.h
swig -c++ -java -package org.rationalityfrontline.jctp -outdir $javaOutputDir -o $cppOutputDir/jctp.cpp jctp.i