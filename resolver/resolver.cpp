#include "resolver.hpp"
#include <map>
#include <iostream>
#include <fstream>

using namespace std;

ofstream out;
addr_t current_addr = 0;
map<string, addr_t> declarations;

int main(int argc, char* argv[]) {
	if(argc != 2) {
		cerr << "Usage: " << argv[0] << " <output symbol table>" << std::endl;
		return 1;
	}

	yyparse();

	out = ofstream(argv[1]);
	if(!out.good()) {
		cout << "Could not open " << argv[1] << "." << endl;
		return 2;
	}

	for(auto const& x : declarations)
		out << x.first << ' ' << x.second << '\n';

	out.close();

	return 0;
}

void increment(size_t count) {
	current_addr += count;
}

void declare(const char* name) {
	if(declarations.find(name) != declarations.end())
		yyerror(string("Redeclaration of \"")+name+"\".");

	declarations[name] = current_addr;
}
