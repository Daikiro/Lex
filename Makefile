CC = gcc
LIBS = -ll -lm
LEX = flex -I
BISON = bison -d -t -v
CFLAGS = -DYYDEBUG=1 -g

DEP=projekt.tab.c projekt.yy.c

.SUFFIXES:                    # Delete the default suffixes
.SUFFIXES: .y .tab.c .l .yy.c # Define our suffix list

.y.tab.c:
	$(BISON) $<

.l.yy.c:
	$(LEX) -o $@ $<

all: projekt

projekt: $(DEP)
	$(CC) -o projekt $(DEP) $(LIBS) $(CFLAGS)

clean: 
	rm -f *.c *.tab.h *.projekt
