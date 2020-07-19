%{
#include "resolver.hpp"
#include <iostream>

using namespace std;

int yylex();
extern int yylineno;
%}

%union {
	unsigned char _addr;
	char* _id;
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

_br:		br sep addr { increment(sizeof(opcode_t) + sizeof(addr_t)); }
	|	ibr sep addr { increment(sizeof(opcode_t) + sizeof(addr_t)); }
	;

_nand:		nand sep addr { increment(sizeof(opcode_t) + sizeof(addr_t)); }
	|	nandi sep addr { increment(sizeof(opcode_t) + sizeof(addr_t)); }
	|	nand sep addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)*2); }
	|	nandi sep addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)*2); }
	|	nandid sep addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)*2); }
	|	nanddi sep addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)*2); }
	|	bnand sep addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)); }
	|	bnandi sep addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)); }
	|	bnand sep addr comma addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)*2); }
	|	bnandi sep addr comma addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)*2); }
	|	bnandid sep addr comma addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)*2); }
	|	bnanddi sep addr comma addr comma addr { increment(sizeof(opcode_t) + sizeof(addr_t)*2); }
	;


declaration:		id colon { declare($1); }
		;

literal:		rawd sep datalist { ; }
		|	rawa sep addrlist { ; }
		;


data:		dec { ; }
	|	hex { ; }
	;

addr:		dec { ; }
	|	hex { ; }
	|	id { ; }
	;


datalist:		data { increment(sizeof(data_t)); }
		|	data comma datalist { ; }
		;

addrlist:		addr { increment(sizeof(addr_t)); }
		|	addr comma addrlist { ; }
		;

%%

void yyerror(const string& s) {
	cerr << "Resolver error at line " << yylineno << ". " << s << endl;
	exit(69);
}
