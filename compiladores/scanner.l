%{
#include <string>
#include "ast.h"
#include "parser.h"
extern int yylineno;
void yyerror(const char* s, ...);
%}

%option noyywrap nodefault yylineno

digs [0-9]+
chars [a-z]+

%%

[ \t]               ; //ignores spaces
[ \n]                  ; //ignores new line

 /* valores dos tipos  */
{digs}              {yylval.inteiro = yytext; return T_VINTEIRO;}
{digs}"."{digs} | {digs}"." | "."{digs}     {yylval.real = yytext; return T_VREAL; }
{TRUE | FALSE} {yylval.booleano = yytext; return T_VBOOLEANO;}

 /* operadores relacionais */
":="				{return T_ATRIBUICAO;}
"="                 {return T_IGUAL;}
"~=" 				{return T_DIFERENTE;}
">"					{return T_MAIOR;}
">="				{return T_MAIORIGUAL;}
"<"					{return T_MENOR;}
"<="				{return T_MENORIGUAL;}

 /* operadores binarios for numbers */
"+"					{return T_ADICAO;}
"-"					{return T_SUBTRACAO;}
"*"					{return T_MULTIPLICACAO;}
"/"					{return T_DIVISAO;}

 /* operadores binarios for booleans */
"AND"				{return T_ERELACIONAL;}
"OR"				{return T_OURELACIONAL;}

 /* operadores unario for booleans */
"~"					{return T_NEGACAO;}

 /* simbolo fim de expressao */
";"					{return T_FIMLINHA;}

 /* simbolos de parenteses */
"("					{return T_PARENTESEE;}
")"					{return T_PARENTESED;}

 /* tipos primitivos */
"int"               {return T_INTEIRO;}
"real"          	{return T_REAL;}
"booleano"			{return T_BOOLEANO;}

 /* outros */
{chars}             {yylval.name = strdup(yytext); return T_ID;}
","                 {return T_VIRGULA;}

 /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
 /*complains about every unknown character*/
.                   {yyerror("Unknown token! %c\n", *yytext);}

%%

void yyerror(const char *s, ...){
    va_list ap;
    va_start(ap, s);
    std::fprintf(stderr, "Line %d: error: ", yylineno);
    std::vfprintf(stderr, s, ap);
}
