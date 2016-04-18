FILES	= src/lexer.c src/parser.c src/main.c
CC		= gcc
CFLAGS	= -g
LDFLAGS	= -lfl

c8asm: $(FILES)
	$(CC) $(FILES) $(CFLAGS) $(LDFLAGS) -o c8asm

src/lexer.c: src/lexer.l
	flex --outfile="src/lexer.c" src/lexer.l

src/parser.c: src/parser.y
	bison --output="src/parser.c" --defines="src/parser.h" src/parser.y

clean:
	rm -f *.o *~ src/parser.c src/parser.h src/lexer.c c8asm
