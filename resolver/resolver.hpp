#ifndef RESOLVER_HPP
#define RESOLVER_HPP

#include <string>

using namespace std;

typedef unsigned char opcode_t;
typedef unsigned char data_t;
typedef unsigned short addr_t;
typedef unsigned long size_t;

int yyparse();
void yyerror(const string&);
void increment(size_t);
void declare(const char*);

#endif
