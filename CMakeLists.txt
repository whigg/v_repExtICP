cmake_minimum_required(VERSION 2.8.11)
project(v_repExtICP)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_MACOSX_RPATH 1)

find_package(Boost REQUIRED)

if(NOT DEFINED ENV{VREP_ROOT})
    message(FATAL_ERROR "Environment variable VREP_ROOT is not set")
endif()
file(TO_CMAKE_PATH "$ENV{VREP_ROOT}" VREP_ROOT)

if(WIN32)
    add_definitions(-DWIN_VREP)
    add_definitions(-DNOMINMAX)
    add_definitions(-Dstrcasecmp=_stricmp)
elseif(UNIX AND NOT APPLE)
    add_definitions(-DLIN_VREP)
elseif(UNIX AND APPLE)
    add_definitions(-DMAC_VREP)
endif()

include_directories(${VREP_ROOT}/programming/include)
include_directories(${CMAKE_BINARY_DIR}/generated)
include_directories(${CMAKE_SOURCE_DIR}/external/libicp/src)
include_directories(${Boost_INCLUDE_DIRS})

add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/generated/stubs.cpp ${CMAKE_BINARY_DIR}/generated/stubs.h ${CMAKE_BINARY_DIR}/generated/lua_calltips.cpp
    COMMAND python ${CMAKE_SOURCE_DIR}/external/v_repStubsGen/generate.py --xml-file ${CMAKE_SOURCE_DIR}/callbacks.xml --lua-file ${CMAKE_SOURCE_DIR}/simExtICP.lua --gen-all ${CMAKE_BINARY_DIR}/generated
    DEPENDS ${CMAKE_SOURCE_DIR}/callbacks.xml)

set(SOURCES
    v_repExtICP.cpp
    external/libicp/src/icp.cpp
    external/libicp/src/icpPointToPlane.cpp
    external/libicp/src/icpPointToPoint.cpp
    external/libicp/src/kdtree.cpp
    external/libicp/src/matrix.cpp
)
add_library(v_repExtICP SHARED ${SOURCES} ${CMAKE_BINARY_DIR}/generated/stubs.cpp "${VREP_ROOT}/programming/common/v_repLib.cpp")

if(WIN32)
    set(SHLWAPI shlwapi)
else()
    set(SHLWAPI)
endif()

target_link_libraries(v_repExtICP ${Boost_LIBRARIES} ${SHLWAPI})
