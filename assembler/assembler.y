%{
#include "assembler.hpp"
#include <iostream>
#include <string>
#include <list>

using namespace std;

int yylex();
%}


%union {
	unsigned char _data;
	unsigned short _addr;
	char* _id;
	list<unsigned char>* _datalist;
	list<unsigned short>* _addrlist;
}

%start line

%token sep
%token comma
%token colon

%token br
%token ibr

%token nand
%token nandi
%token nandid
%token nanddi

%token bnand
%token bnandi
%token bnandid
%token bnanddi

%token <_id> id
%token <_addr> dec
%token <_addr> hex

%type <_addr> addr
%type <_data> data
%type <_datalist> datalist
%type <_addrlist> addrlist

%token rawd
%token rawa

%%

line:		instruction { ; }
	|	instruction line { ; }
	|	declaration { ; }
	|	declaration line { ; }
	|	sep { ; }
	|	sep line { ; }
	|	literal { ; }
	|	literal line { ; }
	;

instruction:		_br { ; }
		|	_nand { ; }
		;

_br:		br sep addr { doBranch(false, $3); }
	|	ibr sep addr { doBranch(true, $3); }
	;

_nand:		nand sep addr { doNand($3, true, 0, true, 0, false, false); }
	|	nandi sep addr { doNand($3, true, 0, true, 0, true, true); }
	|	nand sep addr comma addr { doNand($3, false, $5, true, 0, false, false); }
	|	nandi sep addr comma addr { doNand($3, false, $5, true, 0, true, true); }
	|	nandid sep addr comma addr { doNand($3, false, $5, true, 0, true, false); }
	|	nanddi sep addr comma addr { doNand($3, false, $5, true, 0, false, true); }
	|	bnand sep addr comma addr { doNand($5, true, 0, false, $3, false, false); }
	|	bnandi sep addr comma addr { doNand($5, true, 0, false, $3, true, true); }
	|	bnand sep addr comma addr comma addr { doNand($5, false, $7, false, $3, false, false); }
	|	bnandi sep addr comma addr comma addr { doNand($5, false, $7, false, $3, true, true); }
	|	bnandid sep addr comma addr comma addr { doNand($5, false, $7, false, $3, true, false); }
	|	bnanddi sep addr comma addr comma addr { doNand($5, false, $7, false, $3, false, true); }
	;


declaration:		id colon { ; }

literal:		rawd sep datalist { insertRawData($3); }
		|	rawa sep addrlist { insertRawAddr($3); }
		;


data:		dec { $$ = $1; }
	|	hex { $$ = $1; }
	;

addr:		dec { $$ = $1; }
	|	hex { $$ = $1; }
	|	id { $$ = getDeclaration($1); }
	;


datalist:		data { $$ = new list<data_t>; $$->push_back($1); }
		|	data comma datalist { $3->push_front($1); $$ = $3; }
		;

addrlist:		addr { $$ = new list<addr_t>; $$->push_back($1); }
		|	addr comma addrlist { $3->push_front($1); $$ = $3; }
		;

%%

void yyerror(const string& s) {
	cerr << s;
}
