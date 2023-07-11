%{
#include <stdio.h>
#include <string.h>
#include "Phase2.h"
extern int yylineno;
extern FILE* yyin;
extern int yylex();
extern char* yytext;
extern int yyerror(char *msg);
int varcount=0;
int curscope=0;
void DuplicateErrHandler(char variable[]);
void DecalarationErrHandler(char varible[]);
void AssignmentErrHandler(char variable[]);
%}
%union {struct variable symp ;}
%token START LPAREN RPAREN OP CL END COMMA ENDE
%token INT_LITERAL
%token FLOAT_LITERAL
%token IF ELSE READ PRINT WHILE
%token STRING_LITERAL TRUE FALSE ERROR
%token TIMES PLUS ASG
%token EQ NE LT LE GT GE AND OR NOT 
%token ID
%right ASG
%left OR
%left AND
%left EQ NE
%left PLUS
%left TIMES
%nonassoc NOT
%type <symp> bexpression expression exp factor Type ID 
%token <symp> INT FLOAT BOOLEAN
%%
Start_Program: START statements END;
statements : statements statement
           | statement ;
statement : Dec_stmt | assignment_stmt |  print_stmt  |read_stmt|  condition_stmt  | while_stmt  ;
Dec_stmt: Type ID {
    strcpy($2.type, $1.type);
    if(findvarInScop($2.name , curscope)==0)
    {
       // strcpy($2.type, $1.type);
        //strcpy($2.name, yytext);
    insertvar($2.name , $2.type);
    }
    else 
    yyerror("The variable is previously decalared 1");
};

Type : INT {strcpy($$.type , "int");}
|FLOAT {strcpy($$.type , "float");}
|BOOLEAN {strcpy($$.type , "boolean");}
;

assignment_stmt : ID ASG bexpression {
    if((findvar($1.name ,curscope)==0)){
        printf("%s\n%s | %s kdkdkdff",$1.name ,$1.type,yytext);
       yylineno--;
    yyerror("The variable is not previusly declared oooo"); 
   yylineno++;
    }
    else 
    {
        strcpy( $1.type , findtype($1.name,curscope));
       
        if (strcmp($1.type , $3.type)!=0 && $1.type[0] != '\0')
    {
    printf("type %s name %s | type %s name %s ",$1.type,$1.name,$3.type,$3.name);
            yylineno--;
    yyerror("Incompatible types 1");  
    yylineno++;
    }
 
    }}
;
bexpression:bexpression AND expression
{
   if (!((strcmp($1.type,"boolean")==0) && (strcmp($3.type,"boolean")==0)))
   {
    strcpy( $$.type , "boolean");
   yyerror("Incompatible types && oprates on boolean 2 ");
   }
   else
   strcpy( $$.type , "boolean");
} 
| expression {
    /*if (strcmp($1.type,"boolean")!=0)
    {strcpy( $$.type , "boolean");
        yyerror("Incompatible types oprates on boolean 3 ");}
    else*/
   strcpy( $$.type , $1.type );

};//{if (!(strcmp($1.type,"boolean")==0 && (strcmp($$.type,"boolean")==0)))
//yyerror("Incompatible types 2");}           ;


expression : exp EQ exp   {
if ((strcmp($1.type,$3.type) != 0))
{ strcpy($$.type,"boolean");
yyerror("The operand of relational opration must be the same type 1");} // here
else 
strcpy($$.type,"boolean"); 
}
           | exp NE exp {
            if ((strcmp($1.type,$3.type) != 0))
{ strcpy($$.type,"boolean");
yyerror("The operand of relational opration must be the same type 1");} // here
else 
strcpy($$.type,"boolean");
           }
| exp {strcpy($$.type , $1.type )};
exp : exp PLUS exp {
    if (strcmp($1.type,"float") && (strcmp($3.type,"float")) == 0)
        strcpy($$.type , "float");
    else if ((strcmp($1.type,"float")) && (strcmp($3.type,"int")) == 0 || (strcmp($3.type,"float")) && (strcmp($1.type,"int"))== 0)
        strcpy($$.type , "float");
    else if (strcmp($1.type,"int") && (strcmp($3.type,"int")) == 0 )
        strcpy($$.type , "int");
    else yyerror("Incompatible types 4");
}
    | exp TIMES exp 
    {
    if (strcmp($1.type,"float") && (strcmp($3.type,"float")) == 0)
        strcpy($$.type , "float");
    else if ((strcmp($1.type,"float")) && (strcmp($3.type,"int")) == 0 || (strcmp($3.type,"float")) && (strcmp($1.type,"int"))== 0)
        strcpy($$.type , "float");
    else if (strcmp($1.type,"int") && (strcmp($3.type,"int")) == 0 )
        strcpy($$.type , "int");
    else yyerror("Incompatible types 5");
}                 
    | factor  {strcpy($$.type , $1.type )}// { if (!(strcmp($1.type,"float")==0||(strcmp($1.type,"int")) == 0))
    // print error                     
    ;

factor: LPAREN exp RPAREN  {strcpy($$.type , $2.type );}    
|INT_LITERAL   {strcpy($$.type , "int" );}                                          
|FLOAT_LITERAL  {strcpy($$.type , "float" );}                   
|TRUE     {strcpy($$.type , "boolean" );}   
|FALSE   {strcpy($$.type , "boolean" );}    
| ID {strcpy($$.type , $1.type ); } 
;

print_stmt : PRINT LPAREN ID RPAREN  { 
   if(!findvar($3.name ,curscope)){
    yyerror("Not found in scope");
    DecalarationErrHandler($3.name);
    }}
| PRINT LPAREN STRING_LITERAL RPAREN
;
//if_head statements CL {curscope--;} ENDE

condition_stmt:if_head statements CL {curscope--;} ENDE 
              | condition_stmt OP {curscope++;} statements CL {curscope--;} ENDE ;
if_head : IF LPAREN bexpression {curscope++; if (strcmp($3.type,"boolean")!= 0) yyerror("The expression in IF statement must be of type boolean");} RPAREN OP ;

// if (uuu) {

while_stmt : WHILE LPAREN bexpression {if (strcmp($3.type,"boolean")!=0)
    yyerror("The Condition in While statement must be of type boolean")} RPAREN OP { curscope++;} statements CL {
    curscope--;
}; 

read_stmt: ID ASG READ LPAREN RPAREN{
    if(!findvar($1.name , curscope)){
 yyerror("The variable is not previusly declared 3"); 
    }
};

%%
int main(int argc, char *argv[]){

yyin = fopen(argv[1], "r");

if(!yyparse())
		printf("\nParsing complete\n");
	else
		printf("\nParsing failed\n");
	
	fclose(yyin);

return 0;
}

int yyerror (char* msg)
{
printf(" %s in Line : %d \n",msg,(yylineno));


return 1;


}
int findvar(char name[], int scope){
for(int i=0; i<varcount; i++)
{
if((strcmp(var[i].name, name) == 0) && (var[i].scope <= scope))
        //&& (var[i].scope <= scope)
			return 1;
}   
    return 0; //not found
}

int findvarInScop(char name[], int scope){
    for(int i=0; i<varcount; i++)
		if(strcmp(var[i].name, name) == 0 && var[i].scope == scope)
			return 1;
    return 0; //not found
}

void insertvar(char name[], char type[]){
	strcpy(var[varcount].name, name);	
	//strcpy(var[varcount].type, type);
	var[varcount].scope = curscope;
	varcount++;
}

char* findtype(char name[], int scope){
    for(int i=0; i<varcount; i++)
		if(strcmp(var[i].name, name) == 0) //&& (var[i].scope == scope)){
            {
            printf(" line 217: %s",var[i].type);
			return var[i].type;
            }
    
    return "XXX"; //not found
}

void DuplicateErrHandler(char variable[]){
printf("\n line: %d  Duplicate variable %s ", yylineno , variable);
}

void DecalarationErrHandler(char varible[]){
    printf("\n line: %d : variable '%s' is Undeclared in this scope", yylineno , varible);
 
}
/*int AssignmentErrHandler(char vartype1[] , char vartype2[] ){
    if(strcmp(vartype1,vartype2)!=0){
         printf("\n line: %d : Incompatible type: %s to %s" , yylineno , vartype1 , vartype2 );
        return 0;
    }
    else
    return 1;
}*/
