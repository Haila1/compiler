%{
#include <stdio.h>
#include "phase1.tab.h"
#include <stdlib.h>
#include <string.h>
int yyerror (char* msg);
%}
/* KEEP TRACK OF LINE NUMBER*/
%option yylineno 
delim   [ \t\n]
ws {delim}+
Identifiers [A-Z][a-zA-Z0-9_]*
Comment   ##.*##
INT_NUMBER [-+]?[0-9]+
STRING_LITERAL  \".*\"
FLOAT_LITERAL [-+]?[0-9]*\.[0-9]+

%%
{ws}    {;}
{Comment} {;}
"int" {return INT;}
"if" {return IF;}
"end" {return ENDF;}
"else" {return ELSEF;}
"float" {return FLOAT;}
"boolean" {return BOOL;}
"false" {return F ;}
"true" {return T;}
"while" {return WHILE;}
"read" {return READ;}
"print" {return PRINT;}
"START" {return SSTART;}
"END" {return EEND;}

"+"  {return P;}
"-"  {return M;}
"*" {return multiP;}
"/" {return D;}
"!" {return not;}

"&&" {return and;}
"||" {return or;}

"<=" {return LE;}
">=" {return GE;}
"<>" {return Uneq;}
"<" {return L;}
">" {return G;}
"==" {return EE;}
"=" {return Eq;}

"(" {return ob;}
")" {return cb;}
"{" {return ocb;}
"}" {return ccb;}

{Identifiers} {return ID;}
{INT_NUMBER} {return(INT_LITERAL); }
{FLOAT_LITERAL} {return(FLOAT_LITERAL);}
{STRING_LITERAL} {return(STRING_LITERAL);}

%%
// int yywrap(void){
//     return 1;
// }