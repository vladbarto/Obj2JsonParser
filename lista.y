%{
#include <stdio.h>
#include <stdlib.h>

typedef struct Vertex {
    float x, y, z;
} Vertex;

typedef struct Face {
    int v1, v2, v3; // Indices of vertices
} Face;

Vertex vertices[5000];
Face faces[5000];
int noOfVertices = 0;
int noOfFaces = 0;
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
        vertices[noOfVertices].x = $1;
        vertices[noOfVertices].y = $2;
        vertices[noOfVertices].z = $3;
        noOfVertices++;
    }
    ;

FACE_LINE: FACE_DATA FACE_DATA FACE_DATA
    ;

FACE_DATA: INTEGER '/' INTEGER '/' INTEGER {
        faces[noOfFaces].v1 = $1;
        faces[noOfFaces].v2 = $2;
        faces[noOfFaces].v3 = $3;
        noOfFaces++;
    }
    ;

%%

#include "lex.yy.c"
int main() {
    yyparse();

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
    for(int i = 0; i < noOfFaces; i++)
    {
        printf("\t\t[%d, %d, %d]", faces[i].v1, faces[i].v2, faces[i].v3);
        if(i < noOfFaces - 1)
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
