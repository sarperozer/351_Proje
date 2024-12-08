digit	[0-9]
letter	[A-Za-z]

%{
#include <stdio.h>
#include "y.tab.h"
int lineCount=0;
%}
%%

"+" return PLUS;
"-" return MINUS;
"*" return MULT;
"/" return DIV;
"=" return EQ;
";" return SEMICOLON;
"^" return POWER;
[0-9]+	{
    yylval.int_const = atoi(yytext); 
    return INT;
    }
{letter}({letter}|{digit})*	{
    yylval.str = strdup(yytext); 
    return IDENT;
    }
. {}

%%
