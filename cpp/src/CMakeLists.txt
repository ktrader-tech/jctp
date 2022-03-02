cmake_minimum_required(VERSION 3.16)

if(MSVC)
    add_compile_options(
            $<$<CONFIG:>:/MT> #---------|
            $<$<CONFIG:Debug>:/MTd> #---|-- Statically link the runtime libraries
            $<$<CONFIG:Release>:/MT> #--|
    )
endif()

set(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)

if (WIN32)
    set(include_dir ../include/windows)
elseif(UNIX)
    set(include_dir ../include/linux)
else()
    set(include_dir ../include)
endif ()
include_directories(${include_dir})

link_directories(../../lib)

add_library(
        jctp SHARED
        jctp.h jctp.cpp
)
# 后面的 RPATH 设置原因参考 https://stackoverflow.com/questions/53306837/unsatisfiedlinkerror-when-system-load-ing-dependent-libraries-in-reverse-order
target_link_libraries(jctp thostmduserapi_se thosttraderapi_se -Wl,-rpath,"$ORIGIN")