QMLBIND_INCLUDE = /usr/local/opt/libqmlbind/include
QMLBIND_LIB = /usr/local/opt/libqmlbind/lib

all:
	swift build\
		-Xcc -I$(QMLBIND_INCLUDE)\
		-Xlinker -L$(QMLBIND_LIB)\
		-Xlinker -rpath -Xlinker $(QMLBIND_LIB)
