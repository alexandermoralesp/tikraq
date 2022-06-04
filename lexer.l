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
^nisqa {printf("func");}
^pantasqa       {printf("false");}
^chiqap         {printf("true");}
^sichus        {printf("if");}
^manachayqa {printf("else if");}
^manachayqa {printf("else");}
^chaykama {printf("while");}
^sapakamapaq      {printf("for");}
^qawachiy {printf("print");}
^icha   {printf("or");}
^y      {printf("and");}
^hinalla        {printf("continue");}
^pakiy {printf("break");}

%%
  
int yywrap()
{
 return 1;
}
