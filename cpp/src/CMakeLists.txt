cmake_minimum_required(VERSION 3.16)

if(MSVC)
    add_compile_options(
            $<$<CONFIG:>:/MT> #---------|
            $<$<CONFIG:Debug>:/MTd> #---|-- Statically link the runtime libraries
            $<$<CONFIG:Release>:/MT> #--|
            $<$<C_COMPILER_ID:MSVC>:/utf-8>   #---|
            $<$<CXX_COMPILER_ID:MSVC>:/utf-8> #---|-- Use UTF-8
    )
endif()

set(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)

if (WIN32)
    set(include_dir ../include/windows)
else()
    if(UNIX)
        set(include_dir ../include/linux)
    elseif(APPLE)
        set(include_dir ../include/darwin)
    endif()
    # RPATH 设置原因参考 https://stackoverflow.com/questions/53306837/unsatisfiedlinkerror-when-system-load-ing-dependent-libraries-in-reverse-order
    set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
    set(CMAKE_INSTALL_RPATH $ORIGIN)
endif()
include_directories(${include_dir})

if(APPLE)
    link_directories(../../lib/darwin)
    add_library(
            jctp SHARED
            jctp.h jctp.cpp
    )
    target_link_libraries(jctp thostmduserapi_se thosttraderapi_se ssl crypto comunicationkey)
else()
    link_directories(../../lib)
    add_library(
            jctp SHARED
            jctp.h jctp.cpp
    )
    target_link_libraries(jctp thostmduserapi_se thosttraderapi_se)
endif()