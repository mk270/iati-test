
CCFLAGS = -I/usr/include/libxml2 -fpic
LIBS = -lxml2 -L. -lxml_wrap
LD = gcc

all: xpath

.PHONY: clean
clean:
	rm -f -- xpath *.o *.so *a *~

xpath: libxml_wrap.so

xpath: xpath.o
	$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)

%.o: %.c
	$(CC) $(CCFLAGS) -c -o $@ $<

libxml_wrap.so: libxml_wrap.o
	$(LD) -shared -o $@ $^

.PHONY: install

install: libxml_wrap.so
	install $^ /usr/local/lib
