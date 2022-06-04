/* Programa (lexer) que será llamado desde un parser */

/* Sección DEFINICIONES */
%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"

#define BUSCAR 0

int estado;
int agregar_palabra(int tipo, char *palabra);
int buscar_palabra(char *palabra);

%}

/* Sección REGLAS */
%%
\;           {estado = BUSCAR; return FININSTRUCCION;}
\{          {printf("(lexico) BLOQUEIZQ\n"); return BLOQUEIZQ;}
\}          { printf("(lexico) BLOQUEDER\n"); return BLOQUEDER;}
\(          {printf("(lexico) PARAIZQ\n"); return PARAIZQ;}
\)          { printf("(lexico) PARADER\n"); return PARADER;}
var        { printf("(lexico) DECLARADOR\n"); estado = IDENTIFICADOR; return DECLARADOR;}
nisqa      { printf("(lexico) DECLARADOR\n");  estado = IDENTIFICADOR; return DECLARADOR;}
\=          { printf("(lexico) ASIGNADOR\n"); return ASIGNADOR;}
\+|\-|\/|\* { printf("(lexico) OPERADOR\n"); return OPERADOR;}
\,          { printf("(lexico) SEPARADOR\n"); return SEPARADOR;}
[0-9]+      { printf("(lexico) NUMERICO\n"); return NUMERICO;}
[a-zA-Z][a-zA-Z0-9]*  {/*procesar palabras*/
                if (estado != BUSCAR) {
                    agregar_palabra(estado, yytext);
                    printf("(lexico) IDENTIFICADOR\n");
                    estado = BUSCAR; 
                    return IDENTIFICADOR;
                }
                else {
                    switch ( buscar_palabra(yytext) ) {
                    case IDENTIFICADOR:{ printf("(lexico) IDENTIFICADOR\n"); return IDENTIFICADOR;}
                    default:
                        printf("%s: no se reconoce\n", yytext); 
                        /*no retornar nada*/
                    }
                }
            }/*fin procesar palabras*/

" "           /*ignorar cualquier otro símbolo*/
%%

/* Sección CODIGO USUARIO */
/* definir una lista enlazada de palabras y tipos*/
struct palabra {
    char *nombre_palabra;
    int tipo_palabra;
    struct palabra *sgte;
};

struct palabra *lista = NULL; /*primer elemento de la lista*/

int agregar_palabra(int tipo, char *palabra) {
    struct palabra *p; /*entrada de la lista*/
    
    if ( buscar_palabra(palabra) != BUSCAR ) {
        printf("La palabra %s ya fue definida!!!\n", palabra);
        return 0; //no funciono
    }
    
    /* asignar espacio de memoria */
    p = malloc( sizeof( struct palabra ) );
    p->nombre_palabra = malloc( strlen(palabra) + 1 ); 
    /* copiar datos de palabra */
    strcpy( p->nombre_palabra, palabra );
    p->tipo_palabra = tipo;    
    /* enlazar nueva entrada a lista */
    p->sgte = lista;
    lista = p;
    return 1; //funciono
}

int buscar_palabra(char *palabra){
    struct palabra *p = lista;
    
    /* buscar palabra en la lista */
    while (p != NULL) {
        if ( strcmp(p->nombre_palabra, palabra) == 0 )
            return p->tipo_palabra;
        p = p->sgte;
    }
    
    return BUSCAR; /*no encontrado*/
}