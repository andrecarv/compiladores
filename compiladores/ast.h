/*Abstract Syntax Tree definition*/
#pragma once

#include <iostream>
#include <vector>
#include <string>

extern void yyerror(const char *s, ...);

namespace AST {

//Binary operations
enum Operation { plus, times, minus, division, assign };

class Node;

typedef std::vector<Node*> NodeList; //List of ASTs

class Node {
    public:
        virtual ~Node() {}
        virtual void printTree(){}
        virtual string get_type() { return "NULL"; }
};

class Data : public Node {
    string _value;
    string _type
    Data(string _type, string _value) : _type(_type), _value(_value) {  }
    void printTree();
    string get_type() {return _type;}
}

class BinOp : public Node {
    public:
        Operation op;
        Node *left;
        Node *right;
        BinOp(Node *left, Operation op, Node *right) :
            left(left), right(right), op(op) { }
        void printTree();
        string get_type();
};

class Block : public Node {
    public:
        NodeList lines;
        Block() { }
        void printTree();
};

class Variable : public Node {
     public:
         string id;
         Node *next;
         Variable(std::string id, Node *next) : id(id), next(next) { }
         void printTree();
};

}

