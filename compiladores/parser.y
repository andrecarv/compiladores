%{
#include "ast.h"
#include "st.h"
#include <string>
ST::SymbolTable symtab;  /* main symbol table */
AST::Block *programRoot; /* the root node of our program AST:: */
extern int yylex();
extern void yyerror(const char* s, ...);
%}

%define parse.trace

/* yylval == %union
 * union informs the different ways we can store data
 */
%union {
	using namespace std;
    string inteiro;
    string real;
    string booleano;
    AST::Node *node;
    AST::Block *block;
    const string name;
}

/* token defines our terminal symbols (tokens).
 */
//valores dos tipos
%token <inteiro> T_VINTEIRO
%token <real> T_VREAL
%token <booleano> T_VBOOLEANO
// operadores binarias for numbers
%token T_ADICAO T_SUBTRACAO T_MULTIPLICACAO T_DIVISAO
// operadores relacionais
%token T_ATRIBUICAO T_IGUAL T_DIFERENTE T_MAIOR T_MENOR T_MAIORIGUAL T_MENORIGUAL
// operadores binarios for booleans
%token T_ERELACIONAL T_OURELACIONAL
//operador unario for booleans
%token T_NEGACAO
//
%token T_FIMLINHA
// tipos primitivos
%token T_INTEIRO T_REAL T_BOOLEANO

%token <name> T_ID


/* type defines the type of our nonterminal symbols.
 * Types should match the names used in the union.
 * Example: %type<node> expr
 */
%type <node> expr line varlist
%type <block> lines program

/* Operator precedence for mathematical operators
 * The latest it is listed, the highest the precedence
 */
%left T_ADICAO T_SUBTRACAO
%left T_MULTIPLICACAO T_DIVISAO
%nonassoc error

/* Starting rule 
 */
%start program

%%

program : lines { programRoot = $1; }
        ;

lines   : line { $$ = new AST::Block(); $$->lines.push_back($1); }
        | lines line { if($2 != NULL) $1->lines.push_back($2); }
        ;

line    : T_NL { $$ = NULL; } /*nothing here to be used */
        | expr T_NL /*$$ = $1 when nothing is said*/
        | T_INTEGER varlist T_NL { $$ = $2; }
        | T_DOUBLE varlist T_NL { $$ = $2; }
        | T_ID T_ASSIGN expr {  AST::Node* node = symtab.assignVariable($1);
                                $$ = new AST::BinOp(node,AST::assign,$3); }
        ;

expr    : T_INT { $$ = new AST::Integer($1); }
        | T_DUB { $$ = AST::Double($1[0], $1[1]); }
        | T_ID { $$ = symtab.useVariable($1); }
        | expr T_PLUS expr { $$ = new AST::BinOp($1,AST::plus,$3); }
        | expr T_TIMES expr { $$ = new AST::BinOp($1,AST::times,$3); }
        | expr error { yyerrok; $$ = $1; } /*just a point for error recovery*/
        ;

varlist : T_ID { $$ = symtab.newVariable($1, NULL); }
        | varlist T_COMMA T_ID { $$ = symtab.newVariable($3, $1); }
        ;

%%


