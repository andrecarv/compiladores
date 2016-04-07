%{
#include "ast.h"
#define MAX_VARS 10
AST::Block *programRoot; /* the root node of our program AST:: */
extern int yylex();
extern void yyerror(const char* s, ...);
AST::Variable variables[MAX_VARS];
int n_variables = 0;
AST::Variable get_variable(char* name);
AST::Variable set_variable(char* name, int value);
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
%token T_PLUS T_NL T_MULT T_ATRB

/* type defines the type of our nonterminal symbols.
 * Types should match the names used in the union.
 * Example: %type<node> expr
 */
%type <node> expr line atrb
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
        | atrb T_NL
        | expr T_NL /*$$ = $1 when nothing is said*/
        ;

expr    : T_INT { $$ = new AST::Integer($1); }
        | T_NAM { $$ = get_variable($1);}
        | expr T_PLUS expr { $$ = new AST::BinOp($1,AST::plus,$3); std::cout << "Hello there, I've found a plus sign :)\n";}
        | expr T_MULT expr { $$ = new AST::BinOp($1,AST::mult,$3); std::cout << "Hey, there's a multiplication right here! :D\n";}
        | expr error { yyerrok; $$ = $1; }/*just a point for error recovery*/
        ;
atrb    : T_NAM T_ATRB T_INT { $$ = set_variable($1,$3);
        std::cout << "Hey mothafrogger, variable declared.";}
        
        ;

%%

AST::Variable get_variable(char* name){
    for(AST::Variable v:variables){
        if(v.name == name)
            return v;
    }
    std::cout << "Variável não declarada.";
    exit(0);
    AST::Variable v = new AST::Variable(name, 0);
    return v;
}

AST::Variable set_variable(char* name, int value){
    for(AST::Variable v:variables){
        if(v.name == name){
            v.value = value;
            return v;
        }
    }
    AST::Variable * address = variables;
    for(int i = 0;i<n_variables;i++){
    address++;
    }
    AST::Variable v = AST::Variable(name,value);
    *address = v;
    n_variables++;
    return v;
}
