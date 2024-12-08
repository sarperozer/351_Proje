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
		
		var_map[$1] = atoi($3);
		}
	|
	IDENT EQ subtraction SEMICOLON {
		
		string a = $1;
		string b = $3;

		string out = a + "=" + b + ";" + "\n";

		output.append(out);
		
		var_map[$1] = atoi($3);
		}
	|
	IDENT EQ division SEMICOLON {
				
		string a = $1;
		string b = $3;

		string out = a + "=" + b + ";" + "\n";

		output.append(out);
		
		var_map[$1] = atoi($3);
		}
	|
	IDENT EQ multiplication SEMICOLON {
				
		string a = $1;
		string b = $3;

		string out = a + "=" + b + ";" + "\n";

		output.append(out);
		
		var_map[$1] = atoi($3);
		}
	|
	IDENT EQ power SEMICOLON {
				
		string a = $1;
		string b = $3;

		string out = a + "=" + b + ";" + "\n";

		output.append(out);
		
		var_map[$1] = atoi($3);
		}
	;

declaration:
	IDENT EQ IDENT {
		ident_to_ident_map[$1] = $3;

		if(var_map.find($1) != var_map.end()){
			var_map.erase($1);
		}
	}
	|
	IDENT EQ INT {
		var_map[$1] =  $3;

		if(ident_to_ident_map.find($1) != ident_to_ident_map.end()){
			ident_to_ident_map.erase($1);
		}
	}
	;

addition:
	IDENT PLUS IDENT
	|
	IDENT PLUS INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			int res = const_folding($3, "add", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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
			int res = const_folding($1, "add", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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
		$$ = res_str.c_str();
		}
	;

subtraction:
	IDENT MINUS IDENT
	|
	IDENT MINUS INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			int res = const_folding($3, "sub", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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
			int res = const_folding($1, "sub", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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
		$$ = res_str.c_str();
		}
	;

multiplication:
	IDENT MULT IDENT
	|
	IDENT MULT INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			int res = const_folding($3, "mult", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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
			int res = const_folding($1, "mult", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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
		$$ = res_str.c_str();
		}
	;

division:
	IDENT DIV IDENT
	|
	IDENT DIV INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			int res = const_folding($3, "div", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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
			int res = const_folding($1, "div", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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
		$$ = res_str.c_str();
		}
	;

power:
	IDENT POWER IDENT
	|
	IDENT POWER INT {
		string ident;
		if (ident_to_ident_map.find($1) != ident_to_ident_map.end()) {
			ident = ident_to_ident_map[$1];
		}
		else
			ident = $1;

		if(var_map.find(ident) != var_map.end()){
			int res = const_folding($3, "power", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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
			int res = const_folding($1, "power", var_map[ident]);
			string res_str = to_string(res);
			$$ = res_str.c_str();
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

	ofstream output_file(output_file_name);

	output_file << output;

	output_file.close();
	
    return 0;
}
