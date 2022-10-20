CC = gcc

CFLAGS = -DUNICODE -Wall -g 
CFLAGS += -Ilib/glad/include -Ilib/stb -Ilib/wgl 
CFLAGS += -MT $@ -MMD -MP -MF $*.d

DEPOBJS = lib/glad/src/glad.o lib/stb/stb_image.o 

GEN = -G "MinGW Makefiles"

LDFLAGS = -municode -mwindows -mconsole
LDFLAGS += -lopengl32
LDFLAGS += $(DEPOBJS)

SRC = $(wildcard src/*.c)

OBJ = $(patsubst src/%.c,obj/%.o,$(SRC))
DEP = $(patsubst src/%.c,obj/%.d,$(SRC))

all: dirs obj/menu.o engine

lib/stb/stb_image.o:
	cd lib/stb && \
	$(CC) -x c -c stb_image.h -DSTB_IMAGE_IMPLEMENTATION

lib/glad/src/glad.o:
	cd lib/glad && \
	$(CC) -o src/glad.o -Iinclude -c src/glad.c

dirs:
	mkdir -p ./bin 
	mkdir -p ./obj 

obj/menu.o: src/menu.h src/menu.rc
	windres src/menu.rc -o obj/menu.o

%.o: src/%.c %.d
	$(CC) $(CFLAGS) -o $@ -c $<

obj/%.o: src/%.o
	mv $< $@

obj/%.d: src/%.d
	mv $< $@

include $(wildcard $DEP)

engine: $(OBJ) $(DEP) obj/menu.o $(DEPOBJS)
	$(CC) -o bin/engine.exe $(OBJ) obj/menu.o $(LDFLAGS)

clean:
	rm $(DEPOBJS) -f
	rm -rf bin
	rm -rf obj 
