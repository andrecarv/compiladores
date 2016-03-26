%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calculadora_basica.tab.h"

%}

digito  [0-9]

%%

[ \t]       ; // ignora espaços em branco
{digito}+   {yylval.val_int = atoi(yytext); return T_INT;}
\n          {return T_LINHA;}
"+"         {return T_MAIS;}
"*"         {return T_VEZES;}
"saida"     {return T_SAIR;}
"-"         {return T_MENOS;}
"("         {return T_LPARENTESIS;}
")"         {return T_RPARENTESIS;}


%%
