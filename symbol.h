#include <stdlib.h>
#include <string.h>

#define SYMT_FAILED 0
#define SYMT_SUCCESS 1

typedef struct _sym_t
{
    char *name;
    int val;
    
    struct _sym_t *next;
} sym_t;

sym_t*
symtable_construct_entry (const char *name, int value);

void
symtable_insert (const char *sym_name, int value);

int
symtable_symbol_by_name(int *val, const char *name);

int
symtable_exists (const char *name);

int
symtable_update (const char *name, int newval);