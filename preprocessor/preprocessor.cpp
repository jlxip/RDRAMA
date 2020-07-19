// TODO: %include
// TODO: %define

#include "preprocessor.hpp"
#include <iostream>
#include <fstream>

using namespace std;

string output = "";

int main(int argc, char* argv[]) {
	if(argc != 2) {
		cerr << "Usage: " << argv[0] << " <preprocessed output>" << endl;
		return 1;
	}

	yyparse();

	ofstream out(argv[1]);
	if(!out.good()) {
		cout << "Could not open " << argv[1] << "." << endl;
		return 2;
	}
	out << output;
	out.close();
	return 0;
}

void addSomething(const char* c) {
	output = string(c) + output;
	delete [] c;
}
