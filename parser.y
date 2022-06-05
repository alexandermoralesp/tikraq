
%{
   /* Definition section */
  #include<stdio.h>
  int flag=0;
  
  int yylex();
  int yyerror(char *s);
%}
  
%token NUMBER OPERATOR
%left '+' '-'
%left '*' '/'
%left '='
%right '('
%left ')'

/* Rule Section */
%%
exCondicional: CONDICIONAL {
             printf("Expresion condicional =%d\n", $$);
             return 0;
             }

CONDICIONAL: NUMBER '=' '=' NUMBER {
           $$ = ($1 == $4);
           };
%%
  
//driver code
void main()
{
   yyparse();
   if(flag==0) printf("\nError de sintaxis\n\n");
}
  
int yyerror(char *s)
{
   printf("\nExpresion invalida\n\n");
   flag=1;
}
