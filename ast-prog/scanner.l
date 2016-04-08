%{
#include <string>
#include "ast.h"
#include "parser.h"
extern int yylineno;
void yyerror(const char* s, ...);
%}

%option noyywrap nodefault yylineno

digs [0-9]+
chars [a-z]

%%

[ \t]               ; //ignores spaces
{digs}              {yylval.integer = std::atoi(yytext); return T_INT;}
{chars}+            {yylval.name = yytext; return T_NAM;}
"+"                 {return T_PLUS;}
"sair"              {return T_SAIR;}
"*"                 {return T_MULT;}
"="                 {return T_ATRB;}
\n                  {return T_NL;}
.                   {yyerror("Unknown token! %c\n", *yytext);} /*complains about every unknown character*/

%%

void yyerror(const char *s, ...){
    va_list ap;
    va_start(ap, s);
    std::fprintf(stderr, "Line %d: error: ", yylineno);
    std::vfprintf(stderr, s, ap);
}
