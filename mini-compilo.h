#ifndef MINI_COMPILO_H
#define MINI_COMPILO_H

typedef enum
{
  TYPE_CST,
  TYPE_VAR,
  TYPE_OP,
  TYPE_FCT,
  TYPE_FCT_CALL,
  TYPE_ARG
} TypeNode;

// Arg node
typedef struct
{
  char* typeName;
  char* argId;
  struct Node *next;
} NodeArg;

// Function node
typedef struct
{
  char* funcName;
  char* funcReturnType;
  char* funcReturnId;
  char  funcCount;
  int   stackPtr;
  int   retRegister;

  struct Node *inst;
  struct Node *ret;
  struct Node *arg;

} NodeFunc;

// Constant node
typedef struct
{
  int   val;        // Cst value
  float valF;
  int   cstCount;
} NodeCst;

// Variable node
typedef struct
{
  char* varId;    // Variable identifier
  int varCount;   //
  int stackPtr;   // Variable's position in var stack
} NodeVar;

// Operator node
typedef struct
{
  int name;                 // type d'opérateur : +, -, =, while, print, etc.
  int register_num;         // register
  int nb_children;          // Nombre d'opérandes pour cet opérateur.
  struct Node *operand[3];  // Des pointeurs vers les operands de cet opérateur.
} NodeOp;

// General Node
typedef struct Node
{
  TypeNode type;
  char*    typeCast;
  union
  {
    NodeCst   cst;
    NodeVar   var;
    NodeOp    op;
    NodeFunc  func;
    NodeArg   argl;
  };
} Node;

void sortie(Node *noeud);

// variable stack
char **varStack;
char **varType;
int   *varAccess;       /* number of uses of var[i] */
int   *varLine;         /* line on source file where var[i] is declared */
int   *varInit; /*was init performed during declaration ? */

int    stackSize;

// function stack
char  **fctIdStack;     /* [{id0},{id1},...,{idN-1}]*/
char  **fctTypeStack;   /* [{return type of id0},{return type of id1},...,{return type of idN-1}]*/
char ***fctArgvStack;   /* [{{type}{args of id0}},{{type}{args of id1}},...,{{type}{args of idN-1}}]*/
char ***fctArgtStack;   /* type des arguments des fonctions */

unsigned int    *fctArgcStack;   /* nombre d'arg */
unsigned int   *fctIsDefined;  /* fID[i] = 0 (func declared undefined); != 0 (func declared defined with fID[i] args;  */

int    *fctDefLine;
int    *fctLine;

int ***useOfVar; /*  useOfVar[i] = [type of operator, line]*/

int fctStackSize;
// others
char *retValMain;
int *declaredRegister;
int   num_registre;
int   printCallS;
int   printCall;
FILE *fp;
FILE *data_sect;
FILE *bss_sect;
FILE *text_sect;

#endif
