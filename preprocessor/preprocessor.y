%{
#include "preprocessor.hpp"
#include <iostream>
#include <string.h>

using namespace std;

int yylex();
extern int yylineno;
%}

%union { char* _something; }

%start line

%token comment
%token lbreak
%token <_something> something

%%

line:		comment { ; }
	|	comment line { ; }
	|	something { addSomething($1); }
	|	something line { addSomething($1); }
	|	lbreak { addSomething(strdup("\n")); }
	|	lbreak line { addSomething(strdup("\n")); }
	;

%%

void yyerror(const string& s) {
	cerr << "Preprocessor error at line " << yylineno << ". " << s << endl;
	exit(69);
}
