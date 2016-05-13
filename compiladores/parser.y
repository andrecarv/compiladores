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
%token T_VIRGULA

/* type defines the type of our nonterminal symbols.
 * Types should match the names used in the union.
 * Example: %type<node> expr
 */
%type <node> expr line varlist
%type <block> lines program

/* Operator precedence for mathematical operators
 * The latest it is listed, the highest the precedence
 */
%left T_ADICAO T_SUBTRACAO T_ERELACIONAL T_OURELACIONAL
%left T_MULTIPLICACAO T_DIVISAO T_NEGACAO
%left T_DIFERENTE T_MAIOR T_MENOR T_MAIORIGUAL T_MENORIGUAL
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

line    : T_FIMLINHA { $$ = NULL; } /*nothing here to be used */
        | expr T_FIMLINHA /*$$ = $1 when nothing is said*/
        | T_INTEIRO varlist T_FIMLINHA { $$ = $2; }
        | T_REAL varlist T_FIMLINHA { $$ = $2; }
        | T_BOOLEANO varlist T_FIMLINHA { $$ = $2; }
        | T_ID T_ATRIBUICAO expr {  AST::Node* node = symtab.assignVariable($1);
                                $$ = new AST::BinOp(node,AST::assign,$3); }
        ;

expr    : T_VINTEIRO { $$ = new AST::Data("inteiro", $1); }
        | T_VREAL { $$ = AST::Data("real", $1);}
        | T_VBOOLEANO  { $$ = AST:Data("booleano", $1); } 
        | T_ID { $$ = symtab.useVariable($1); }
        | expr T_ADICAO expr { $$ = new AST::BinOp($1,AST::plus,$3); }
        | expr T_SUBTRACAO expr { $$ = new AST::BinOp($1, AST::minus, $3); }
        | expr T_MULTIPLICACAO expr { $$ = new AST::BinOp($1,AST::times,$3); }
        | expr T_DIVISAO expr { $$ = new AST::BinOp($1, AST::division, $3); }
        | expr error { yyerrok; $$ = $1; } /*just a point for error recovery*/
        ;

varlist : T_ID { $$ = symtab.newVariable($1, NULL); }
        | varlist T_VIRGULA T_ID { $$ = symtab.newVariable($3, $1); }
        ;

%%


