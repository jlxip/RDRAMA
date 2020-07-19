#ifndef PREPROCESSOR_HPP
#define PREPROCESSOR_HPP

#include <string>

using namespace std;

int yyparse();
void yyerror(const string&);
void addSomething(const char*);

#endif
