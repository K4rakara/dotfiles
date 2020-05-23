#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main(int argc, char* argv[])
{
	if (argc >= 2)
	{
		for (int i = 0; i < argc; i++)
		{
			if (i != 0)
			{
				string thisLine;
				ifstream thisFile (argv[i]);
				if (thisFile.is_open())
				{
					while (getline(thisFile, thisLine)) cout << thisLine << "\n";
					thisFile.close();
				}
				else
				{
					cerr << "Could not open file \"" << argv[i] << "\".\n";
					return 1;
				}
			}
		}
	}
	else
	{
		cout
			<< "Fcat\n"
			<< "===\n"
			<< "Quick and dirty file concatenation.\n"
			<< "Simply pass file names to this program and they will be outputted to stdout.\n"
			<< "Liscensed under the MIT liscense.\n"
			<< "Source availible at https://github.com/K4rakara/mini-utils.\n";
	}
	return 0;
}
