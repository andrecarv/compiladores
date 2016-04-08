%{
#include "ast.h"
#include <map>
AST::Block *programRoot; /* the root node of our program AST:: */
extern int yylex();
extern void yyerror(const char* s, ...);
std::map<char*,int> var_table;
void create_var(char * name);
%}

/* yylval == %union
 * union informs the different ways we can store data
 */
%union {
    int integer;
    char * name;
    AST::Node *node;
    AST::Block *block;
}

/* token defines our terminal symbols (tokens).
 */
%token <integer> T_INT
%token <name> T_NAM
%token T_PLUS T_MULT T_DEF T_COMMA T_NL

/* type defines the type of our nonterminal symbols.
 * Types should match the names used in the union.
 * Example: %type<node> expr
 */
%type <node> expr line def mdef
%type <block> lines program

/* Operator precedence for mathematical operators
 * The latest it is listed, the highest the precedence
 */
%left T_PLUS
%left T_MULT
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
        | def T_NL
        ;

expr    : T_INT { $$ = new AST::Integer($1); }
        | T_NAM { $$ = new AST::Integer(var_table[$1]);}
        | expr T_PLUS expr { $$ = new AST::BinOp($1,AST::plus,$3); std::cout << "soma identificada.\n"; }
        | expr T_MULT expr { $$ = new AST::BinOp($1,AST::mult,$3);
                                std::cout << "multiplicação identificada.\n";}
        | expr error { yyerrok; $$ = $1; } /*just a point for error recovery*/
        ;

def     : T_DEF mdef {$$ = $2;}
        ;

mdef : mdef T_COMMA T_NAM {create_var($3);}
     | T_NAM {create_var($1);}
     ;

%%

void create_var(char* name){
    if(var_table.find(name) == var_table.end()) {
        var_table[name] = 0;
        std::cout << "variavel " << name << " criada.\n";
        return;
    }
    std::cout << "variavel ja declarada.\n";
}



