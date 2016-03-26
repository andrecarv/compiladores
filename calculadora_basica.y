%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
%}

%union {
	int val_int;
}

%token<val_int> T_INT
%token T_MAIS T_MENOS T_VEZES T_SIGNAL
%token T_LPARENTESIS T_RPARENTESIS
%token T_LINHA T_SAIR

%type<val_int> expr

%left T_MAIS T_MENOS
%left T_VEZES
%right T_SIGNAL
%%

calculo :
        | calculo linha
;

linha   : T_LINHA
        | expr T_LINHA      { printf("\tResultado = %i\n", $1); } 
        | T_SAIR T_LINHA    { printf("~\\o\n"); exit(0); }
;

expr    : T_INT             { $$ = $1; }
        | expr T_MAIS expr  { $$ = $1 + $3; }
        | expr T_VEZES expr { $$ = $1 * $3; }
        | expr T_MENOS expr { $$ = $1 - $3; }
        | T_SIGNAL expr { $$ = - $2; }
        | T_LPARENTESIS expr T_RPARENTESIS { $$ = ( $2 ); }
;

%%

int main() {
    yyin = stdin;
    do {
        yyparse();
    } while(!feof(yyin));
    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Erro durante o parsing: %s\n", s);
    exit(1);
}
