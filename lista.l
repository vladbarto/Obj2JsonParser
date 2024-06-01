%{
// extern int yylval;
#include <stdlib.h>
%}
%option noyywrap

integer [0-9]+
float [+-]?[0-9]*(\.)[0-9]+
vertex "v "
face "f"
%%
{float}     {
                yylval.fval = atof(yytext);
                return FLOAT;
            }
[0-9]+   {
                yylval.ival = atoi(yytext);
                return INTEGER;
            }
\n          {
                yylval.cval = yytext[0];
                return EOL;
            }
{vertex}    {   return VERTEX;  } 
{face}      {   return FACE;    }
"/"         {   return '/';   }
[\t ]       ;
.           ;
%%

