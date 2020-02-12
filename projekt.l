%{
#include <string.h>
#include "projekt.tab.h"

int symcount = 0;
int lineno = 1;
char symtable[64][32]; 
%}

%%

"program"     			return program_TOKEN;

"begin"	      			return begin_TOKEN;
"end" 					return end_TOKEN;

"if"					return if_TOKEN;
"then"					return then_TOKEN;

";"  		    		return semicolon_TOKEN;
"."           			return dot_TOKEN;
":="          			return assign_TOKEN;

"and"					return and_TOKEN;
"+" 	        		return plus_TOKEN;

[a-zA-Z][a-zA-Z0-9]*   	yylval = symlook(yytext); return ID;
[0-9]+			     	yylval = symlook(yytext); return NUM;

[ \t] ;   				
[;].* ;   				
\n						lineno++;

.						return yytext[0];

%%

int symlook(char *symbol) 
    {
	int i = 0;

	while (i < symcount && strcmp(symbol, symtable[i]))
		i++;
		
	if (i < symcount)
		return i;
	else {
		strncpy(symtable[symcount], symbol, 8); /* Add to table */
		return symcount++;
	}
}
