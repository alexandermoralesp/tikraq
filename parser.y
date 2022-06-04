/* Analizador sintactico para reconocer sentencias  */

/* Sección DEFINICIONES */
%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyerror(char *s);
%}

/* Sección REGLAS */
%token IDENTIFICADOR OPERADOR PARA PARC 
%left '+' '-'
%left '*' '/'
%left '^'
%right '('
%lefft ')'

%%
expresion: IDENTIFICADOR OPERADOR expresion  {printf("Exp. arit compuesta \n");}
    | PARA expresion PARC  {printf("Exp. aritmetica con parentesis \n");}
    | IDENTIFICADOR         {printf("Exp. aritmetica simple \n");}
    ;
E: E'+'E {$$ = $1 + $3;}
    | E'-'E {$$ = $1 - $3;}
    | E'*'E {$$ = $1 * $3;}
    | E'/'E {$$ = $1 / $3;}
    | E'^'E {$$ = $1 ^ $3;}
    | IDENTIFICADOR {$$ = $1;}
    ;
%%

/* Sección CODIGO USUARIO */
FILE *yyin;
int main() {
    agregar_palabra(OPERADOR,"+");
    agregar_palabra(OPERADOR,"-");
    agregar_palabra(OPERADOR,"*");
    agregar_palabra(OPERADOR,"/");
    agregar_palabra(PARA,"(");
    agregar_palabra(PARC,")");
    do {
        yyparse();
    } while ( !feof(yyin) );
    
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "JS:%s\n", s);
    return 0;
}
