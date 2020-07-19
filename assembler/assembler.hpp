#ifndef ASSEMBLER_HPP
#define ASSEMBLER_HPP

#include <string>
#include <list>

using namespace std;

typedef unsigned char data_t;
typedef unsigned short addr_t;

int yyparse();
void yyerror(const string& s);
void doBranch(bool indirect, addr_t addr);
void doNand(addr_t orig, bool isItself, addr_t dest, bool isByte, unsigned char bit, bool io, bool id);
addr_t getDeclaration(char* str);
void insertRawData(list<data_t>* raw);
void insertRawAddr(list<addr_t>* raw);

#endif
