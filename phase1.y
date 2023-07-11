%{
#include <stdio.h>
#include "phase1.tab.h"
extern int yylineno;
extern FILE* yyin;
extern int yyerror (char* msg);
extern char * yytext;
int yylex();
%}
%token ID
%token INT_LITERAL
%token STRING_LITERAL
%token FLOAT_LITERAL
%token LE GE INT IF ENDF ELSEF FLOAT BOOL F L G Uneq EE Eq
%token ob cb ocb ccb
%left INT IF ENDF ELSEF FLOAT F T
%token P M multiP D not
%token and or
%token WHILE READ PRINT SSTART EEND
%right Eq
%left or
%left and
%left EE Uneq
%left L LE G GE
%left P M
%left multiP D
%right not

%%
Program:SSTART Statements EEND
         ;
Statements:Statements Statement
            |Statement
            ;
Statement:Dec_stmt 
           |Assignment_stmt 
           |Print_stmt 
           |Read_stmt 
           |Condition_stmt 
           |While_stmt
           ;
Dec_stmt:Type ID
        ;
Type:INT 
    |FLOAT 
    |BOOL
    ;
Assignment_stmt:ID Eq Expression
                ;
Expression:exp EE exp
          |exp Uneq exp
          |exp L exp
          |exp LE exp
          |exp G exp 
          |exp GE exp 
          |exp
          ;
exp:exp P exp
    |exp M exp
    |exp multiP exp
    |exp D exp
    |exp or exp
    |exp and exp 
    |not exp 
    |ob exp cb
    |INT_LITERAL 
    |FLOAT_LITERAL 
    |ID 
    |T
    |F
    ;
Print_stmt:PRINT ob ID cb 
          |PRINT ob STRING_LITERAL cb
          ;
Read_stmt:ID Eq READ ob cb
          ;
Condition_stmt:IF ob Expression cb ocb Statements ccb ENDF
              |IF ob Expression cb ocb Statements ccb ENDF ELSEF ocb Statements ccb ENDF 
              ;
While_stmt:WHILE ob Expression cb ocb Statements ccb
             ;

%%

int main(int argc, char *argv[])
{
    // don't change this part
yyin = fopen(argv[1], "r" ); 
if(!yyparse())
        printf("\nParsing complete\n");
    else
        printf("\nParsing failed\n");
    
    fclose(yyin);

return 0;
}

extern int yyerror (char* msg)
{
 printf("line %d: %s at '%s'\n",yylineno,msg,yytext);
return 1;
}
