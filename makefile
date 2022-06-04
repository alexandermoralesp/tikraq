all: 
	flex lexer.l
	bison -d parser.y
	gcc -c lex.yy.c parser.tab.c
	gcc -o lexpar lex.yy.o parser.tab.o -ll