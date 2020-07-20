#include "assembler.hpp"
#include <iostream>
#include <fstream>
#include <map>
#include <sstream>

using namespace std;

map<string, addr_t> declarations;
ofstream out;


int main(int argc, char* argv[]) {
	if(argc != 3) {
		cerr << "Usage: " << argv[0] << " <path to output binary> <symbol table>" << std::endl;
		return 1;
	}

	ifstream symbols(argv[2]);
	if(!symbols.good()) {
		cout << "Could not open " << argv[2] << "." << endl;
		return 2;
	}

	string lastLine;
	while(getline(symbols, lastLine)) {
		stringstream ss;
		ss << lastLine;

		string theName;
		addr_t theAddr;
		ss >> theName >> theAddr;
		declarations[theName] = theAddr;
	}

	symbols.close();


	out = ofstream(argv[1], ofstream::binary);
	if(!out.good()) {
		cerr << "Could not open " << argv[1] << "." << endl;
		return 3;
	}

	yyparse();
	out.close();

	return 0;
}

#define BIT_NAND     0b10000000
#define BIT_INDIRECT 0b01000000
#define BIT_BYTE     0b01000000
#define BIT_ITSELF   0b00100000
#define BIT_IO       0b00000010
#define BIT_ID       0b00000001

void doBranch(bool indirect, unsigned short addr) {
	char opcode = indirect ? BIT_INDIRECT : 0;
	out.write(&opcode, 1);
	out.write((char*)&addr, 2);
}

void doNand(addr_t orig, bool isItself, addr_t dest, bool isByte, unsigned char bit, bool io, bool id) {
	char opcode = BIT_NAND;
	if(isByte) {
		opcode |= BIT_BYTE;
	} else {
		if(bit > 7)
			yyerror("Bit is greater than 7.");

		opcode |= bit << 2;
	}

	if(isItself)
		opcode |= BIT_ITSELF;
	if(io)
		opcode |= BIT_IO;
	if(id)
		opcode |= BIT_ID;

	out.write(&opcode, 1);
	out.write((char*)&orig, 2);
	if(!isItself)
		out.write((char*)&dest, 2);
}

addr_t getDeclaration(char* str) {
	auto it = declarations.find(str);

	if(it == declarations.end())
		yyerror(string("\"")+str+"\" is not declared.");

	return (*it).second;
}

void insertRawData(list<data_t>* raw) {
	for(auto const& x : *raw)
		out.write((char*)&x, 1);
	delete raw;
}

void insertRawAddr(list<addr_t>* raw) {
	for(auto const& x : *raw)
		out.write((char*)&x, 2);
	delete raw;
}
