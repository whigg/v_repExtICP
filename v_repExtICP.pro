QT -= core gui

TARGET = v_repExtICP
TEMPLATE = lib

CONFIG += shared debug_and_release
INCLUDEPATH += "../include"
INCLUDEPATH += "external/libicp/src"
INCLUDEPATH += "generated"

*-msvc* {
	QMAKE_CXXFLAGS += -O2
	QMAKE_CXXFLAGS += -W3
}
*-g++*|*clang* {
	QMAKE_CXXFLAGS += -O3
	QMAKE_CFLAGS += -O3
        QMAKE_CXXFLAGS_WARN_ON = -Wall -Wno-unused-parameter
        QMAKE_CXXFLAGS_WARN_OFF = -Wall -Wno-unused-parameter
}

win32 {
    DEFINES += WIN_VREP
    DEFINES += NOMINMAX
    DEFINES += strcasecmp=_stricmp
    INCLUDEPATH += "c:/local/boost_1_62_0"
}

macx {
    QMAKE_MAC_SDK = macosx10.12
    DEFINES += MAC_VREP
    INCLUDEPATH += "/usr/local/Cellar/boost/1.63.0/include/"
}

unix:!macx {
    DEFINES += LIN_VREP
}

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/lib
    } else {
        target.path = /usr/lib
    }
    INSTALLS += target
}

gen_all.target = generated/stubs.h
gen_all.output = generated/stubs.h
gen_all.input = callbacks.xml simExtCustomUI.lua
gen_all.commands = python \"$$PWD/external/v_repStubsGen/generate.py\" --xml-file \"$$PWD/callbacks.xml\" --gen-all \"$$PWD/generated/\"
QMAKE_EXTRA_TARGETS += gen_all
PRE_TARGETDEPS += generated/stubs.h

HEADERS += \
    ../include/v_repLib.h \
    generated/stubs.h \
    v_repExtICP.h \
    external/libicp/src/icp.h \
    external/libicp/src/icpPointToPlane.h \
    external/libicp/src/icpPointToPoint.h \
    external/libicp/src/kdtree.h \
    external/libicp/src/matrix.h

SOURCES += \
    ../common/v_repLib.cpp \
    generated/stubs.cpp \
    v_repExtICP.cpp \
    external/libicp/src/icp.cpp \
    external/libicp/src/icpPointToPlane.cpp \
    external/libicp/src/icpPointToPoint.cpp \
    external/libicp/src/kdtree.cpp \
    external/libicp/src/matrix.cpp

