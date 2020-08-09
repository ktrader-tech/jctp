set javaOutputDir=..\java\src\main\java\org\rationalityfrontline\jctp
set cppOutputDir=..\cpp\src
rmdir /s/q %javaOutputDir%
mkdir %javaOutputDir%
del %cppOutputDir%\jctp.cpp
del %cppOutputDir%\jctp.h
swig -c++ -java -package org.rationalityfrontline.jctp -outdir %javaOutputDir% -o %cppOutputDir%\jctp.cpp jctp.i