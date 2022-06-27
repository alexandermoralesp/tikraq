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
%token IF
%token ELSE
%token WHILE
%token FOR

%left '+' '-'
%left '*' '/'
%left '^'
%left '<' '=' "<=" ">="
%right '('
%left ')'

%%
s:
    programa

programa:
    instruccion programa
    | instruccion

instruccion:
    bloque_for
    | bloque_if
    | bloque_while
    | retorno
    | declaracion 
    | asignacion FININSTRUCCION
    | expresion FININSTRUCCION

bloque_instrucciones:
    BLOQUEIZQ programa BLOQUEDER {printf("Bloque de instrucciones\n");}

inmediato:
    NUMERICO
    | CADENA

declaracion:
    TIPO IDENTIFICADOR FININSTRUCCION                                       {printf("Declaracion de variable\n");}
    | TIPO declaracion_funcion bloque_instrucciones FININSTRUCCION  {printf("Declaracion de funcion\n");}
    | TIPO IDENTIFICADOR ASIGNADOR expresion FININSTRUCCION                 {printf("Declaracion de variable con asignacion\n");}

asignacion:
    IDENTIFICADOR ASIGNADOR expresion                        {printf("Asignacion\n");}

retorno:
    RETORNO expresion FININSTRUCCION                                        {printf("Retorno\n");}

primitivo:
    PRIMITIVO PARAIZQ llamada_parametros PARADER              {printf("Llamada a primitivo\n");}

expresion:
    expresion_rec {printf("Expresion\n");}

expresion_rec:
    expresion_rec OPERADOR expresion_rec
    | PARAIZQ expresion_rec PARADER
    | IDENTIFICADOR
    | inmediato
    | primitivo
    | llamada_funcion

declaracion_funcion:
    IDENTIFICADOR PARAIZQ declaracion_parametros PARADER {printf("Cabezera de declaracion Funcion\n");}
declaracion_parametros:
    TIPO IDENTIFICADOR declaracion_parametros_rec
    | %empty
declaracion_parametros_rec:
    SEPARADOR TIPO IDENTIFICADOR declaracion_parametros_rec
    | %empty

llamada_funcion:
    IDENTIFICADOR PARAIZQ llamada_parametros PARADER {printf("Llamada Funcion\n");}
llamada_parametros:
    expresion llamada_parametros_rec
    | %empty
llamada_parametros_rec:
    SEPARADOR expresion llamada_parametros_rec
    | %empty

bloque_if:
    IF PARAIZQ expresion PARADER bloque_instrucciones bloque_else {printf("Bloque if\n");} |
    IF expresion PARADER bloque_instrucciones {printf("[ERROR] Falta añadir el parentesis izquierdo en la expresion\n");} |
    IF PARAIZQ expresion bloque_instrucciones {printf("[ERROR] Falta añadir el parentesis derecho en la expresion\n");} | %empty


bloque_else:
    ELSE bloque_instrucciones {printf("Bloque else\n");}
    | %empty

bloque_while:
    WHILE PARAIZQ expresion PARADER bloque_instrucciones {printf("Bloque while\n");} |
    WHILE expresion PARADER bloque_instrucciones {printf("[ERROR] Falta añadir el parentesis izquierdo en la expresion\n");} |
    WHILE PARAIZQ expresion bloque_instrucciones {printf("[ERROR] Falta añadir el parentesis derecho en la expresion\n");}

declaracion_for:
    declaracion
    | FININSTRUCCION

condicion_for:
    expresion FININSTRUCCION
    | FININSTRUCCION

actualizacion_for:
    asignacion 
    | %empty

bloque_for:
    FOR PARAIZQ declaracion_for condicion_for actualizacion_for PARADER bloque_instrucciones {printf("Bloque for\n");}
%%

/* Sección CODIGO USUARIO */
FILE *yyin0;
int main() {
    agregar_palabra(FININSTRUCCION,";");
    agregar_palabra(PRIMITIVO,"imprimiy");
    agregar_palabra(PRIMITIVO,"yaykuchiy");
    agregar_palabra(RETORNO,"kutichiy");
    agregar_palabra(TIPO,"yupay");
    agregar_palabra(TIPO,"qaytu");
    agregar_palabra(TIPO,"manaimapas");
    agregar_palabra(IF,"sichus");
    agregar_palabra(ELSE,"manachayqa");
    agregar_palabra(WHILE,"chaykama");
    agregar_palabra(FOR,"chaymantapacha");
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
    } while ( !feof(yyin0) );
    
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "JS:%s\n", s);
    return 0;
}
