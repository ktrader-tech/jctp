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

target_link_libraries(jctp thostmduserapi_se thosttraderapi_se)