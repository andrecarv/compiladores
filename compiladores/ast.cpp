#include "ast.h"
#include "st.h"

using namespace AST;

extern ST::SymbolTable symtab;

/* Print methods */
void Data::printTree(){
    std::cout <<"valor "<< _type << " " << _value;
    return;
}


void BinOp::printTree(){
    std::cout << "(";
    left->printTree();
    switch(op){
        case plus: std::cout << " soma " << get_type() << " "; break;
        case times: std::cout << " multiplicacao " << get_type(); break;
        case minus: std::cout << " menos " << get_type(); break;
        case division: std::cout << " divisao " << get_type(); break;
        case greater: std::cout << " maior " << get_type(); break;
        case lesser: std::cout << " menor " << get_type(); break;
        case greater_eq : std::cout << " maior igual " << get_type(); break;
        case lesser_eq : std::cout << " menor igual " << get_type(); break;
        case logical_and : std::cout << " e booleano "; break;
        case logical_or : std::cout << " ou booleano "; break;
        case equals : std::cout << " igual " << get_type(); break;
        case different : std::cout << " diferente " << get_type(); break;
        case assign: std::cout << " := "; break;
    }
    right->printTree();
    std::cout << ")";
    return;
}

void UnOp::printTree() {
    std::cout << "("
        switch(op){
            case negate: std::cout << "negacao unaria " << right->get_type();
            case opposite: std::cout << "menos unario " << right->get_type();
        }
    std::cout << ")"
    right->printTree();
}

void Block::printTree(){
    for (Node* line: lines) {
        line->printTree();
        std::cout << std::endl;
    }
}

void Variable::printTree(){
    if (next != NULL){
        next->printTree();
        std::cout << ", ";
    }
    std::cout << id;
}

/* get_type method */

string BinOp::get_type() {
     if (left->get_type() == right->get_type())
         return left->get_type();
     else {
        if (left->get_type() == "real")
            return left->get_type();
        else
            return right->get_type();
     }
}
