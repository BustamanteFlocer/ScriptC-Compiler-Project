%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "scriptc-yacc.tab.h"

%}

%%
"display"                           {return display;}

"int"                               {yylval.s = strdup(yytext); return INT;}
"float"                             {yylval.s = strdup(yytext); return FLOAT;}
"char"                              {yylval.s = strdup(yytext); return CHAR;}
"%d"|"%f"                           {yylval.s = strdup(yytext); return SPECIFIER;}
                             
[-]?[0-9]+                          {yylval.i = atoi(yytext); return INTEGERS;}
[-]?[0-9]+\.[0-9]+                  {yylval.f = atof(yytext); return DECIMALS;}       
[a-zA-Z_]+                          {yylval.s = strdup(yytext); return IDENTIFIER;}
\'([^']|\\\')*\'                        {
                                          yylval.s = strdup(yytext+1);
                                          if (yylval.s[yyleng-2] != '\'')
                                              yyerror("improperly terminated string");
                                          else
                                              yylval.s[yyleng-2] = 0;
                                          return CHARACTER;
                                        }
\"([^"]|\\\")*\"                        {
                                          yylval.s = strdup(yytext+1);
                                          if (yylval.s[yyleng-2] != '"')
                                              yyerror("improperly terminated string");
                                          else
                                              yylval.s[yyleng-2] = 0;
                                          return WORD;
                                        }
\n                                  {return NEWLINE;}


[ \t\n]                             ;
[-+*/=":,()]                        {return yytext[0];}
.                                   {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}