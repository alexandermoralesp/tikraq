%{
/* Seccion de definiciones */
  #include<stdio.h>
  #include "parser.tab.h"
  extern int yylval;
%}

/* Seccion de reglas  */
%%
[0-9]+ {
          yylval = atoi(yytext); // asignar el valor semantico
          return NUMBER;
       }
("(") return '(';
(")") return ')';
[\t] ;
[\n] return 0;
(" ") {}
. return yytext[0];
^var       {printf("auto");}  
^funcion   {printf("void");}
^si        {printf("if");}
^tambien   {printf("else if");}
^sino      {printf("else");}
^mientras  {printf("while");}
^para      {printf("para");}
^imprimir  {printf("print");}
%%
  
int yywrap()
{
 return 1;
}
