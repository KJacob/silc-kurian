%{
#include<stdlib.h>
#include <stdio.h>
#include <string.h>

#define CH_NUMBER 'N'
#define CH_PLUS '+'
#define CH_MINUS '-'
#define CH_MUL '*'
#define CH_DIV '/'

char **g_stack;

typedef struct _tree{
    char op;
    struct _tree *left, *right;
    int val;
} tree;

/* Tree functions. */

tree*
construct_node (char op, tree *left, tree *right, int val)
{
    tree* root = (tree *) malloc (sizeof(tree));
    
    root->left = left;
    root->right = right;
    root->op = op;
    root->val = val;
    
    return root;
}

int
evaluate_tree (tree *root)
{
    int leftval, rightval, retval;
    
    if (!root)
    {
        /* Return some garbage value. */
        return 0;
    }
    
    leftval = evaluate_tree (root->left);
    rightval = evaluate_tree (root->right);
    
    switch (root->op)
    {
        case CH_NUMBER:
        retval = root->val;
        break;
        
        case CH_PLUS:
        retval = leftval + rightval;
        break;
        
        case CH_MINUS:
        retval = leftval - rightval;
        break;
        
        case CH_MUL:
        retval = leftval * rightval;
        break;
        
        case CH_DIV:
        retval = leftval / rightval;
        break;
    }
    
    return retval;
}

char **
construct_stack (int size)
{
   char **stack;
   
   stack = (char **) malloc ((size + 1) * sizeof(char *));
   
   return stack;
}

void
push (const char *string)
{
   g_stack = g_stack + 1;
   *g_stack = strdup (string);
}

char *
peek ()
{
   return *g_stack;
}

void
pop ()
{
   free (*g_stack);
   g_stack = g_stack - 1;
}

void
modify_stack (char op)
{
    char *out_text;
    
    out_text = (char *) malloc (sizeof(char) * 200);
    
    sprintf (out_text, "%c %s %s", op, *(g_stack - 1), *g_stack);
    pop();
    pop();
    push (out_text);
}
 
void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
        return 1;
} 

int  
main()
{
   g_stack = construct_stack (100);

   yyparse();
} 

%}

%union{
    int number;
    struct _tree *syn_tree;
}

%token NUM

%type <number> NUM
%type <syn_tree> expr

%left '+' '-'
%left '*' '/'

%%

program:
		program statement '\n'
		|
		;
		
statement:
expr	{ printf ("Prefix version of the command: %s", peek()); pop(); printf("\n%d\n", evaluate_tree($1)); }
		|
		;
				
expr:
NUM { $$ = construct_node(CH_NUMBER, NULL, NULL, $1); char num[40]; sprintf(num, "%d", $1); push (num);}
		|
expr '+' expr	{ $$ = construct_node(CH_PLUS, $1, $3, 0); modify_stack('+');}
		|
		expr '-' expr	{ $$ = construct_node(CH_MINUS, $1, $3, 0); modify_stack('-'); }
		|
		expr '*' expr	{ $$ = construct_node(CH_MUL, $1, $3, 0); modify_stack('*'); }
		|
		expr '/' expr	{ $$ = construct_node(CH_MUL, $1, $3, 0); modify_stack('/'); }
        |
'(' expr ')'    { $$ = $2; }
		;
%%
