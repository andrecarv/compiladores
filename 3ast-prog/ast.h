/*Abstract Syntax Tree definition*/
#pragma once

#include <iostream>
#include <vector>

extern void yyerror(const char *s, ...);

namespace AST {

//Binary operations
enum Operation { plus, times, assign };

class Node;

typedef std::vector<Node*> NodeList; //List of ASTs

template<typename T>
class Node {
    public:
        virtual ~Node() {}
        virtual void printTree(){}
        virtual T computeTree() { return NULL; }
};

template<typename T>
class Data : public Node<T> {
    T value;
    Data(T value) : value(value) {  }
    void printTree();
    T computeTree();
}

template<typename T, typename U>
class BinOp : public Node<NULL> {
    public:
        Operation op;
        Node *left;
        Node *right;
        auto result;
        BinOp(Node<T> *left, Operation op, Node<U> *right) :
            left(left), right(right), op(op) { }
        void printTree();
        void computeTree();
        void getResult(void * result) {*result = this.result;}
};

template<typename T>
class Block : public Node<T> {
    public:
        NodeList lines;
        Block() { }
        void printTree();
        T computeTree();
};

template<typename T>
class Variable : public Node<T> {
     public:
         std::string id;
         Node *next;
         Variable(std::string id, Node *next) : id(id), next(next) { }
         void printTree();
         T computeTree();
};

}

