%{
#include <stdio.h>
#include <stdlib.h>

// Coordonatele unui Vertex pe axa Ox, Oy, Oz sunt retinute in aceasta structura
typedef struct Vertex {
    float x, y, z;
} Vertex;

// Face este o tripleta de tipul "v/vt/vn" (vertex/vertex texture/vertex normal)
// v = v1, vt = v2, vn = v3
typedef struct Face {
    int v1, v2, v3;
} Face;

Vertex vertices[5000];
Face faces[5000];
int noOfVertices = 0;
int noOfFaces = 0;

// Pentru ca yylval sa recunoasca si float-uri, e nevoie de un union
// yylval by default poate stoca int-uri
#define YYSTYPE_IS_DECLARED
typedef union {
    int ival;
    float fval;
    char cval;
} YYSTYPE;

extern YYSTYPE yylval;
%}

%token FLOAT INTEGER EOL VERTEX FACE

%%

S   : LS
    ;

LS  : LS L
    | L
    | /*empty*/
    ;

L   : VERTEX VERTEX_LINE TERMINATOR
    | FACE FACE_LINE TERMINATOR
    | OTHERS TERMINATOR
    | TERMINATOR
    | /*empty*/
    ;

TERMINATOR: EOL
          | /*empty*/
          ;

OTHERS: OTHERS INTEGER 
    | OTHERS FLOAT
    | INTEGER
    | FLOAT
    ;

VERTEX_LINE: FLOAT FLOAT FLOAT { 
        // se ajunge la o linie de tipul "v 1.670000 2.340000 -5.400000"
        vertices[noOfVertices].x = $1.fval;
        vertices[noOfVertices].y = $2.fval;
        vertices[noOfVertices].z = $3.fval;
        noOfVertices++;
    }
    ;

FACE_LINE: FACE_DATA FACE_DATA FACE_DATA
    ;

FACE_DATA: INTEGER '/' INTEGER '/' INTEGER {
        // se ajunge la o tripleta de tipul "v/vt/vn"
        faces[noOfFaces].v1 = $1.ival;
        faces[noOfFaces].v2 = $2.ival;
        faces[noOfFaces].v3 = $3.ival;
        noOfFaces++;
    }
    ;

%%

#include "lex.yy.c"
int main() {
    yyparse();

    // scrierea in fisierul de iesire in format json
    printf("{\n\t\"vertices\": [\n");
    for(int i = 0; i < noOfVertices; i++)
    {
        printf("\t\t[%f, %f, %f]", vertices[i].x, vertices[i].y, vertices[i].z);
        if(i < noOfVertices - 1)
            printf(",");
        printf("\n");
    }
    printf("\t],\n");

    printf("\t\"faces\": [\n");
    for(int i = 0; i < noOfFaces-2; i = i + 3)
    {
        printf("\t\t[%d, %d, %d]", 
            faces[i].v1 - 1, 
            faces[i+1].v1 - 1, 
            faces[i+2].v1 - 1);
        if(i < noOfFaces - 4)
            printf(",");
        printf("\n");
    }
    printf("\t]\n}");

    return 0;
}

int yyerror (char *msg) {
    fprintf (stderr, "YACC: %s\n", msg);
    return 0;
}
