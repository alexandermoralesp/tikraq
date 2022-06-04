/* Analizador sintactico para reconocer sentencias  */

/* Sección DEFINICIONES */
%{
int agregar_palabra(int tipo, char *palabra);
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyerror(char *s);
%}

/* Sección REGLAS */
%token FININSTRUCCION
%token IDENTIFICADOR
%token ASIGNADOR
%token OPERADOR
%token PARAIZQ PARADER
%token NUMERICO

%left '+' '-'
%left '*' '/'
%left '^'
%right '('
%left ')'

%%
programa:
    instruccion programa
    | instruccion

instruccion:
    declaracion FININSTRUCCION
    | expresion FININSTRUCCION

declaracion:
    IDENTIFICADOR {printf("Variable declarada \n");}
    | IDENTIFICADOR ASIGNADOR expresion {printf("Variable decalarada con valor inicial\n");}

expresion:
    aritmetica {printf("Expresion aritmetica\n");}
aritmetica:
    aritmetica OPERADOR aritmetica
    | PARAIZQ aritmetica PARADER
    | IDENTIFICADOR
    | NUMERICO
%%

/* Sección CODIGO USUARIO */
FILE *yyin;
int main() {
    agregar_palabra(FININSTRUCCION,";");
    agregar_palabra(ASIGNADOR,"=");
    agregar_palabra(OPERADOR,"+");
    agregar_palabra(OPERADOR,"-");
    agregar_palabra(OPERADOR,"*");
    agregar_palabra(OPERADOR,"/");
    agregar_palabra(PARAIZQ,"(");
    agregar_palabra(PARADER,")");
    do {
        yyparse();
    } while ( !feof(yyin) );
    
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "JS:%s\n", s);
    return 0;
}
