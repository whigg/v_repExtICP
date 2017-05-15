TARGET = v_repExtICP
TEMPLATE = lib

CONFIG += shared debug_and_release
INCLUDEPATH += "../include"

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

stubs_h.target = stubs.h
stubs_h.output = stubs.h
stubs_h.input = callbacks.xml
stubs_h.commands = python -m v_repStubsGen -H stubs.h callbacks.xml
QMAKE_EXTRA_TARGETS += stubs_h
PRE_TARGETDEPS += stubs.h

stubs_cpp.target = stubs.cpp
stubs_cpp.output = stubs.cpp
stubs_cpp.input = callbacks.xml
stubs_cpp.commands = python -m v_repStubsGen -C stubs.cpp callbacks.xml
QMAKE_EXTRA_TARGETS += stubs_cpp
PRE_TARGETDEPS += stubs.cpp

reference_html.target = reference.html
reference_html.output = reference.html
reference_html.input = callbacks.xml
reference_html.commands = xsltproc --path \"$$PWD/\" -o reference.html callbacks.xsl callbacks.xml
QMAKE_EXTRA_TARGETS += reference_html
PRE_TARGETDEPS += reference.html

HEADERS += \
    stubs.h \
    v_repExtICP.h

SOURCES += \
    stubs.cpp \
    v_repExtICP.cpp

