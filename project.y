%{
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include "y.tab.h"
#include <map>
#include <fstream>
extern FILE *yyin;

using namespace std;
extern int lineCount;
void yyerror(string s);

int yylex();

string output = "";
bool constent_folded = false;

map<string, int> var_map;
map<string, string> ident_to_ident_map;

%}

%union{
	const char* str;
	int int_const;
}

%token <str> IDENT
%token <int_const> INT
%token PLUS MINUS MULT DIV EQ SEMICOLON POWER
%type <str> addition subtraction multiplication division power
%%

lines:
	line lines
	|
	line
	;

line:
	declaration SEMICOLON
	|
	IDENT EQ addition SEMICOLON {
		
		string a = $1;
		string b = $3;

		string out = a + "=" + b + ";" + "\n";

		output.append(out);
		
		}
	|
	IDENT EQ subtraction SEMICOLON {
		
		string a = $1;
		string b = $3;

		/*if (constent_folded){
			int c = atoi($3);

			var_map[$1] = c;
			constent_folded = false;
		}*/

		string out = a + "=" + b + ";" + "\n";

		output.append(out);
		
		}
	|
	IDENT EQ division SEMICOLON {
				
		string a = $1;
		string b = $3;

		string out = a + "=" + b + ";" + "\n";

		output.append(out);
		
		}
	|
	IDENT EQ multiplication SEMICOLON {
				
		string a = $1;
		string b = $3;

		string out = a + "=" + b + ";" + "\n";

		output.append(out);
		
		}
	|
	IDENT EQ power SEMICOLON {
				
		string a = $1;
		string b = $3;

		string out = a + "=" + b + ";" + "\n";

		output.append(out);
		
		}
	;

declaration:
	IDENT EQ IDENT {
		ident_to_ident_map[$1] = $3;

		if(var_map.find($1) != var_map.end()){
			var_map.erase($1);
		}

		string a = $1;
		string b = $3;

		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()){
			b = ident_to_ident_map[$3];
		}

		if(var_map.find($3) != var_map.end()) {
			b = to_string(var_map[$3]);
		}

		string out = a + "=" + b + ";" + "\n";
		output.append(out);
	}
	|
	IDENT EQ INT {
		var_map[$1] =  $3;

		string a = $1;
		string b = to_string($3);

		if(ident_to_ident_map.find($1) != ident_to_ident_map.end()){
			ident_to_ident_map.erase($1);
		}

		string out = a + "=" + b + ";" + "\n";
		output.append(out);
	}
	;

addition:
	IDENT PLUS IDENT {
		string ident1;
		string ident2;
		string a;
		string b;

		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident1 = ident_to_ident_map[$1];
		}
		else
			ident1 = $1;

		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident2 = ident_to_ident_map[$3];
		}
		else
			ident2 = $3;

		a = ident1;
		b = ident2;

		if (var_map.find(ident1) != var_map.end()){
			a = to_string(var_map[ident1]);
		}

		if (var_map.find(ident2) != var_map.end()){
			b = to_string(var_map[ident2]);
		}

		string out = a + "+" + b;
		$$ = out.c_str();
	}
	|
	IDENT PLUS INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			
			int k = var_map[ident];
			string a = to_string(k);
			string b = to_string($3);

			string out = a + "+" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($3);
			string out = ident + "+" + a;
			$$ = out.c_str();
		}
	}
	|
	INT PLUS IDENT {
		string ident;
		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$3];
		}
		else
			ident = $3;

		if(var_map.find(ident) != var_map.end()){

			int k = var_map[ident];
			string b = to_string(k);
			string a = to_string($1);

			string out = a + "+" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($1);
			string out = a + "+" + ident;
			$$ = out.c_str();
		}
	}
	|
	INT PLUS INT {
		int res = const_folding($1, "add", $3);
		string res_str = to_string(res);
		constent_folded = true;
		$$ = res_str.c_str();
		}
	;

subtraction:
	IDENT MINUS IDENT{
		string ident1;
		string ident2;
		string a;
		string b;

		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident1 = ident_to_ident_map[$1];
		}
		else
			ident1 = $1;

		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident2 = ident_to_ident_map[$3];
		}
		else
			ident2 = $3;

		a = ident1;
		b = ident2;

		if (var_map.find(ident1) != var_map.end()){
			a = to_string(var_map[ident1]);
		}

		if (var_map.find(ident2) != var_map.end()){
			b = to_string(var_map[ident2]);
		}

		string out = a + "-" + b;
		$$ = out.c_str();
	}
	|
	IDENT MINUS INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			int k = var_map[ident];
			string a = to_string(k);
			string b = to_string($3);

			string out = a + "-" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($3);
			string out = ident + "-" + a;
			$$ = out.c_str();
		}
	}
	|
	INT MINUS IDENT {
		string ident;
		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$3];
		}
		else
			ident = $3;

		if(var_map.find(ident) != var_map.end()){
			int k = var_map[ident];
			string b = to_string(k);
			string a = to_string($1);

			string out = a + "-" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($1);
			string out = a + "-" + ident;
			$$ = out.c_str();
		}
	}
	|
	INT MINUS INT {
		int res = const_folding($1, "sub", $3);
		string res_str = to_string(res);
		constent_folded = true;
		$$ = res_str.c_str();
		}
	;

multiplication:
	IDENT MULT IDENT {
		string ident1;
		string ident2;
		string a;
		string b;

		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident1 = ident_to_ident_map[$1];
		}
		else
			ident1 = $1;

		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident2 = ident_to_ident_map[$3];
		}
		else
			ident2 = $3;

		a = ident1;
		b = ident2;

		if (var_map.find(ident1) != var_map.end()){
			a = to_string(var_map[ident1]);
		}

		if (var_map.find(ident2) != var_map.end()){
			b = to_string(var_map[ident2]);
		}

		string out = a + "*" + b;
		$$ = out.c_str();
	}
	|
	IDENT MULT INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			int k = var_map[ident];
			string a = to_string(k);
			string b = to_string($3);

			string out = a + "*" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($3);
			string out = ident + "*" + a;
			$$ = out.c_str();
		}
	}
	|
	INT MULT IDENT {
		string ident;
		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$3];
		}
		else
			ident = $3;

		if(var_map.find(ident) != var_map.end()){
			int k = var_map[ident];
			string b = to_string(k);
			string a = to_string($1);

			string out = a + "*" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($1);
			string out = a + "*" + ident;
			$$ = out.c_str();
		}
	}
	|
	INT MULT INT {
		int res = const_folding($1, "mult", $3);
		string res_str = to_string(res);
		constent_folded = true;
		$$ = res_str.c_str();
		}
	;

division:
	IDENT DIV IDENT {
		string ident1;
		string ident2;
		string a;
		string b;

		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident1 = ident_to_ident_map[$1];
		}
		else
			ident1 = $1;

		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident2 = ident_to_ident_map[$3];
		}
		else
			ident2 = $3;

		a = ident1;
		b = ident2;

		if (var_map.find(ident1) != var_map.end()){
			a = to_string(var_map[ident1]);
		}

		if (var_map.find(ident2) != var_map.end()){
			b = to_string(var_map[ident2]);
		}

		string out = a + "/" + b;
		$$ = out.c_str();
	}
	|
	IDENT DIV INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			int k = var_map[ident];
			string a = to_string(k);
			string b = to_string($3);

			string out = a + "/" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($3);
			string out = ident + "/" + a;
			$$ = out.c_str();
		}
	}
	|
	INT DIV IDENT {
		string ident;
		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$3];
		}
		else
			ident = $3;

		if(var_map.find(ident) != var_map.end()){
			int k = var_map[ident];
			string b = to_string(k);
			string a = to_string($1);

			string out = a + "/" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($1);
			string out = a + "/" + ident;
			$$ = out.c_str();
		}
	}
	|
	INT DIV INT {
		int res = const_folding($1, "div", $3);
		string res_str = to_string(res);
		constent_folded = true;
		$$ = res_str.c_str();
		}
	;

power:
	IDENT POWER IDENT {
		string ident1;
		string ident2;
		string a;
		string b;

		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident1 = ident_to_ident_map[$1];
		}
		else
			ident1 = $1;

		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident2 = ident_to_ident_map[$3];
		}
		else
			ident2 = $3;

		a = ident1;
		b = ident2;

		if (var_map.find(ident1) != var_map.end()){
			a = to_string(var_map[ident1]);
		}

		if (var_map.find(ident2) != var_map.end()){
			b = to_string(var_map[ident2]);
		}

		string out = a + "^" + b;
		$$ = out.c_str();
	}
	|
	IDENT POWER INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			int k = var_map[ident];
			string a = to_string(k);
			string b = to_string($3);

			string out = a + "^" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($3);
			string out = ident + "^" + a;
			$$ = out.c_str();
		}
	}
	|
	INT POWER IDENT {
		string ident;
		if (ident_to_ident_map.find($3) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$3];
		}
		else
			ident = $3;

		if(var_map.find(ident) != var_map.end()){
			int k = var_map[ident];
			string b = to_string(k);
			string a = to_string($1);

			string out = a + "^" + b;
			$$ = out.c_str();
		}
		else{
			string a = to_string($1);
			string out = a + "^" + ident;
			$$ = out.c_str();
		}
	}
	|
	INT POWER INT {
		int res = const_folding($1, "power", $3);
		string res_str = to_string(res);
		constent_folded = true;
		$$ = res_str.c_str();
		}
	;

%%

int const_folding(int number1, string operation, int number2){
	
	if(operation == "add"){
		int res = number1 + number2;
		return res;
	}
	else if(operation == "sub"){
		int res = number1 - number2;
		return res;
	}
	else if(operation == "mult"){
		int res = number1 * number2;
		return res;
	}
	else if(operation == "div"){
		int res = number1 / number2;
		return res;
	}
	else if(operation == "power"){

		int res = 1;

		if (number2 > 0){
			for (int i = 0; i < number2; i++)
				res *= number1;

			return res;
		}
		else if (number2 < 0){
			for (int i = 0; i < number2; i++)
				res *= number1;

			res = 1 / res;
			return res;
		}
		else return 1;
	}
	else
		return -1;
}

void yyerror(string s){
	cout<<"Syntax error at line "<<lineCount<<endl;
	exit(1);
}
int yywrap(){
	return 1;
}
int main(int argc, char *argv[])
{
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);

	string str = argv[1];

	int start_position_to_erase = str.find(".txt");
	str.erase(start_position_to_erase, 4);

	string output_file_name = str + "'s_output.txt";

	ofstream output_file;

	output_file.open(output_file_name);

	output_file << output;

	output_file.close();
	
    return 0;
}
