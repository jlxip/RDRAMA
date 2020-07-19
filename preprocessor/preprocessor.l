%{
#include <list>
#include <string>

using namespace std;

#include "y.tab.h"

void yyerror(const string& s);
int yylex();
%}

%%
";".*	{ return comment; }
"\n"	{ return lbreak; }
.	{ yylval._something = strdup(yytext); return something; }
%%

int yywrap(void) {
	return 1;
}
