%{
#include <string>

using namespace std;

#include "y.tab.h"

void yyerror(const string& s);
int yylex();
%}

%%
(?i:br)		{ return br; }
(?i:ibr)		{ return ibr; }

(?i:nand)		{ return nand; }
(?i:nandd)		{ return nand; }
(?i:nanddd)		{ return nand; }

(?i:nandi)		{ return nandi; }
(?i:nandii)		{ return nandi; }

(?i:nandid)		{ return nandid; }
(?i:nanddi)		{ return nanddi; }

(?i:bnand)		{ return bnand; }
(?i:bnandd)		{ return bnand; }
(?i:bnanddd)		{ return bnand; }

(?i:bnandi)		{ return bnandi; }
(?i:bnandii)		{ return bnandi; }

(?i:bnandid)		{ return bnandid; }
(?i:bnanddi)		{ return bnanddi; }

(?i:rawd)		{ return rawd; }
(?i:rawa)		{ return rawa; }

[0-9]+			{ yylval._addr = atoi(yytext); return dec; }
"0x"[0-9a-fA-F]+	{ yylval._addr = stoul(yytext, nullptr, 16); return hex; }
[a-zA-Z][a-zA-Z0-9]*	{ yylval._id = strdup(yytext); return id; }

[ \t]+			{ return sep; }
","[ ]*		{ return comma; }
":"[ ]*		{ return colon; }

.			{ yyerror(string("Unexpected character: ")+yytext); }
%%

int yywrap(void) {
	return 1;
}
