LIBQMLBIND_DIR = ../libqmlbind

all:
	swift build\
		-Xcc -I$(LIBQMLBIND_DIR)/qmlbind/include\
		-Xlinker -L$(LIBQMLBIND_DIR)/qmlbind\
		-Xlinker -rpath -Xlinker $(LIBQMLBIND_DIR)/qmlbind
