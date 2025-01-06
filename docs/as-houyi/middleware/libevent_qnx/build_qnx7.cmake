set (CMAKE_SYSTEM_NAME QNX)
set (CMAKE_SYSTEM_VERSION 7.1.0)
set (CMAKE_SYSTEM_PROCESSOR aarch64)
# set (TOOLCHAIN QNX)

set (CMAKE_SHARED_LIBRARY_PREFIX "lib")
set (CMAKE_SHARED_LIBRARY_SUFFIX ".so")
set (CMAKE_STATIC_LIBRARY_PREFIX "lib")
set (CMAKE_STATIC_LIBRARY_SUFFIX ".a")


if (DEFINED ENV{QNX7_ROOT})
    set (QNX_ROOT $ENV{QNX7_ROOT})
    string (REPLACE "\\" "/" QNX_ROOT "${QNX_ROOT}")
    # message(FATAL_ERROR "################# ${QNX_ROOT}")
endif ()

# set (QNX_TARGET "${QNX_ROOT}/target/qnx7")
set (QNX_CONFIGURATION "${QNX_ROOT}/.qnx")

# set (ENV{QNX_TARGET} "${QNX_TARGET}")
set (ENV{QNX_CONFIGURATION} "${QNX_CONFIGURATION}")
set (ENV{PATH} "$ENV{PATH};${QNX_ROOT}/host/linux/x86_64/usr/bin;${QNX_ROOT}/.qnx/bin")

set (BIN_PREFIX "ntoaarch64")

# set (CMAKE_MAKE_PROGRAM "${QNX_ROOT}/host/linux/x86_64/usr/bin/make")
# set (CMAKE_SH           "${QNX_ROOT}/host/linux/x86_64/usr/bin/sh")
# set (CMAKE_AR           "${QNX_ROOT}/host/linux/x86_64/usr/bin/${BIN_PREFIX}-ar")
# set (CMAKE_RANLIB       "${QNX_ROOT}/host/linux/x86_64/usr/bin/${BIN_PREFIX}-ranlib")
# set (CMAKE_NM           "${QNX_ROOT}/host/linux/x86_64/usr/bin/${BIN_PREFIX}-nm")
# set (CMAKE_OBJCOPY      "${QNX_ROOT}/host/linux/x86_64/usr/bin/${BIN_PREFIX}-objcopy")
# set (CMAKE_OBJDUMP      "${QNX_ROOT}/host/linux/x86_64/usr/bin/${BIN_PREFIX}-objdump")
# set (CMAKE_LINKER       "${QNX_ROOT}/host/linux/x86_64/usr/bin/${BIN_PREFIX}-ld")
# set (CMAKE_STRIP        "${QNX_ROOT}/host/linux/x86_64/usr/bin/${BIN_PREFIX}-strip")

set (CMAKE_C_COMPILER "${QNX_ROOT}/host/linux/x86_64/usr/bin/${BIN_PREFIX}-gcc")
set (CMAKE_CXX_COMPILER "${QNX_ROOT}/host/linux/x86_64/usr/bin/${BIN_PREFIX}-c++")

# message(FATAL_ERROR "###CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
# add_definitions(-D_QNX_SOURCE -DAI_ADDRCONFIG=0 -DAI_V4MAPPED=0 -DSA_RESTART=0)
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-undefined")

set (CMAKE_SYSROOT "$ENV{QNX_ROOT}")
set (CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
set (CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set (CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set (CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


# INCLUDE_DIRECTORIES("$ENV{QNX_TARGET}/usr/include/c++/8.3.0/parallel")

link_libraries(socket)