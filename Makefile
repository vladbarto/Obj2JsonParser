cube.json: a.out cube.obj 
	./a.out <cube.obj >cube.json
		
a.out: y.tab.c
	gcc y.tab.c 
y.tab.c:  *.y lex.yy.c
	yacc *.y
lex.yy.c: *.l
	lex *.l