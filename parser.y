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
%token DECLARADOR
%token SEPARADOR
%token BLOQUEIZQ BLOQUEDER
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
s:
    programa

programa:
    instruccion programa
    | instruccion

instruccion:
    declaracion FININSTRUCCION
    | asignacion FININSTRUCCION
    | expresion FININSTRUCCION

declaracion:
    DECLARADOR IDENTIFICADOR {printf("Declaracion de variable\n");}
    | DECLARADOR declaracion_funcion BLOQUEIZQ programa BLOQUEDER {printf("Declaracion de funcion\n");}
    | DECLARADOR IDENTIFICADOR ASIGNADOR expresion {printf("Declaracion de variable con asignacion\n");}

asignacion:
    IDENTIFICADOR ASIGNADOR expresion {printf("Asignacion\n");}

expresion:
    aritmetica {printf("Expresion aritmetica\n");}
aritmetica:
    aritmetica OPERADOR aritmetica
    | PARAIZQ aritmetica PARADER
    | IDENTIFICADOR
    | NUMERICO
    | llamada_funcion

declaracion_funcion:
    IDENTIFICADOR PARAIZQ declaracion_parametros PARADER {printf("Declaracion Funcion\n");}
declaracion_parametros:
    DECLARADOR IDENTIFICADOR declaracion_parametros_rec
    | %empty
declaracion_parametros_rec:
    SEPARADOR DECLARADOR IDENTIFICADOR declaracion_parametros_rec
    | %empty

llamada_funcion:
    IDENTIFICADOR PARAIZQ llamada_parametros PARADER {printf("Llamada Funcion\n");}
llamada_parametros:
    IDENTIFICADOR llamada_parametros_rec
    | %empty
llamada_parametros_rec:
    SEPARADOR IDENTIFICADOR llamada_parametros_rec
    | %empty

%%

/* Sección CODIGO USUARIO */
FILE *yyin;
int main() {
    agregar_palabra(FININSTRUCCION,";");
    agregar_palabra(DECLARADOR,"nisqa");
    agregar_palabra(DECLARADOR,"var");
    agregar_palabra(ASIGNADOR,"=");
    agregar_palabra(OPERADOR,"+");
    agregar_palabra(OPERADOR,"-");
    agregar_palabra(OPERADOR,"*");
    agregar_palabra(OPERADOR,"/");
    agregar_palabra(PARAIZQ,"(");
    agregar_palabra(PARADER,")");
    agregar_palabra(BLOQUEIZQ,"{");
    agregar_palabra(BLOQUEDER,"}");
    do {
        yyparse();
    } while ( !feof(yyin) );
    
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "JS:%s\n", s);
    return 0;
}
