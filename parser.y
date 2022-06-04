
%{
   /* Definition section */
  #include<stdio.h>
  int flag=0;
  
  int yylex();
  int yyerror(char *s);
%}
  
%token NUMBER
%left '+' '-'
%left '*' '/'
%right '('
%left ')'

/* Rule Section */
%%
exAritmetica: E {
         printf("\nResultado = %d\n", $$);
         return 0;
        };
E: E'+'E {$$ = $1 + $3;}
    |E'-'E {$$ = $1 - $3;}
    |E'*'E {$$ = $1 * $3;}
    |E'/'E {$$ = $1 / $3;}
    |'('E')' {$$ = ($2);}
    | NUMBER {$$ = $1;}
    ;
%%
  
//driver code
void main()
{
   printf("Ingresar una expresion aritmetica : \n");
  
   yyparse();
   if(flag==0) printf("\n Expresion aritmetica valida \n\n");
}
  
int yyerror(char *s)
{
   printf("\nExpresion invalida\n\n");
   flag=1;
}
