%{
#include <stdio.h>
#include "y.tab.h"
%}
%%

/* identifiers */
[a-zA-Z]+ {
	yylval = strdup(yytext);
	return IDENT;
}

	/* integers */
[0-9]+	{
				yylval=atoi(yytext);
				return NUM;
			}

	/* operators */
[+*-/()\n]	{
				return *yytext;
			}
[\t]	;
			
.	yyerror("error");				
%%
