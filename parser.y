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
%token TIPO
%token SEPARADOR
%token BLOQUEIZQ BLOQUEDER
%token ASIGNADOR
%token OPERADOR
%token PARAIZQ PARADER
%token NUMERICO
%token CADENA
%token RETORNO
%token PRIMITIVO

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
    declaracion 
    | asignacion 
    | retorno
    | primitivo 
    | expresion FININSTRUCCION


declaracion:
    TIPO IDENTIFICADOR FININSTRUCCION                                       {printf("Declaracion de variable\n");}
    | TIPO declaracion_funcion BLOQUEIZQ programa BLOQUEDER FININSTRUCCION  {printf("Declaracion de funcion\n");}
    | TIPO IDENTIFICADOR ASIGNADOR expresion FININSTRUCCION                 {printf("Declaracion de variable con asignacion\n");}

asignacion:
    IDENTIFICADOR ASIGNADOR expresion FININSTRUCCION                        {printf("Asignacion\n");}

retorno:
    RETORNO expresion FININSTRUCCION                                        {printf("Retorno\n");}

primitivo:
    PRIMITIVO PARAIZQ llamada_parametros PARADER FININSTRUCCION             {printf("Llamada a primitivo\n");}

expresion:
    expresion_rec {printf("Expresion\n");}

expresion_rec:
    expresion_rec OPERADOR expresion_rec
    | PARAIZQ expresion_rec PARADER
    | IDENTIFICADOR
    | NUMERICO
    | CADENA
    | llamada_funcion

declaracion_funcion:
    IDENTIFICADOR PARAIZQ declaracion_parametros PARADER {printf("Declaracion Funcion\n");}
declaracion_parametros:
    TIPO IDENTIFICADOR declaracion_parametros_rec
    | %empty
declaracion_parametros_rec:
    SEPARADOR TIPO IDENTIFICADOR declaracion_parametros_rec
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
    agregar_palabra(PRIMITIVO,"imprimiy");
    agregar_palabra(RETORNO,"kutichiy");
    agregar_palabra(TIPO,"yupay");
    agregar_palabra(TIPO,"qaytu");
    agregar_palabra(TIPO,"manaimapas");
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
