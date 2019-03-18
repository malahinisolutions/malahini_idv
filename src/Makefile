CC=g++
LINK:=$(CXX)
CFLAGS=-c -Wall

LDFLAGS = -static

DEFS += $(addprefix -I,$(CURDIR) $(CURDIR)/obj $(BOOST_INCLUDE_PATH) $(OPENSSL_INCLUDE_PATH))
LIBS = $(addprefix -L,$(BOOST_LIB_PATH) $(OPENSSL_LIB_PATH))

LIBS += -l boost_system$(BOOST_LIB_SUFFIX) \
   -l boost_filesystem$(BOOST_LIB_SUFFIX) \
   -l boost_program_options$(BOOST_LIB_SUFFIX) \
   -l ssl \
   -l crypto

SOURCES=main.cpp util.cpp signer.cpp
OBJS=$(SOURCES:.cpp=.o)
EXECUTABLE=signaten

signaten:$(OBJS:obj/%=obj/%)
	$(LINK) $(xCXXFLAGS) -o $@ $^ $(xLDFLAGS) $(LIBS)

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	-rm -f *.o
