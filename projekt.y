%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int trasovani = 0;
int syntaxe = 0;
int err = 0;

extern int lineno;


void yyerror(char *);
int yylex(void);
int symlook(char *);
void TiskPravidla(int);

%}

%token program_TOKEN begin_TOKEN end_TOKEN if_TOKEN then_TOKEN semicolon_TOKEN dot_TOKEN assign_TOKEN and_TOKEN plus_TOKEN ID NUM

%%
PROG:program_TOKEN ID semicolon_TOKEN BLOCK dot_TOKEN{
		TiskPravidla(1);
	};		
BLOCK:begin_TOKEN LIST end_TOKEN{
		TiskPravidla(2);
	};
LIST:STMT{
		TiskPravidla(3);
	}|STMT semicolon_TOKEN LIST{
		TiskPravidla(4);
	};
STMT:BLOCK{
		TiskPravidla(5);
	}|if_TOKEN EXPR then_TOKEN STMT{
		TiskPravidla(6);
	}|ID assign_TOKEN EXPR{
		TiskPravidla(7);
	}|error{ 
		err = 1; 
	};
EXPR : EXPR plus_TOKEN EXPR{
		TiskPravidla(8);
	}|EXPR and_TOKEN EXPR{ 
		TiskPravidla(9);
	}|ID{ 
		TiskPravidla(10);
	}|NUM{ 
		TiskPravidla(11);
	};
%%
 
int main(char argc, char** argv)
{
	int i;
	for (i = 1; i < argc; i++) {
		if(!strcmp(argv[i], "-t")) { 
			trasovani = 1; 
		} else if(!strcmp(argv[i], "-d")) {
			syntaxe = 1;
		}else if(!strcmp(argv[i], "-h")) {
			printf("Nabidka:\n");
			printf("-h \t napoveda\n");
			printf("-t \t sekvencni vypis cisel pouzitych pravidel\n");
			printf("-d \t kontrola syntaxe\n\n");
			
			return 0;
		} else {
			printf("Chyba parametru.");
		}
	}
	
	yyparse();
	
	if (syntaxe == 1) {
		if (err == 0) {
			printf("Syntax OK\n");
		} else {
			printf("Syntax ERROR\n"); 
		}
	}
	
	return 0;
}

void TiskPravidla(int i) {
	if (trasovani == 0) { return; }
	
	printf("Reducing by rule %d", i);
		
	printf("\n");
}

void yyerror(char *s)
{
	fprintf(stderr, "Chyba na radku %d: %s\n", lineno, s);
}