struct variable{
char name[20];
int scope;
char type[20];
}symp;
struct variable var[20];//assumption: the max number of variable is 20
int findvar(char name[], int scope);
void insertvar(char name[], char type[]);
char* findtype(char name[], int scope);
int findvarInScop(char name[], int scope);

// void DuplicateErrHandler(char variable[]);
