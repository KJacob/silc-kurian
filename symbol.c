#include "symbol.h"

static sym_t *sym_table = NULL;

sym_t*
symtable_construct_entry (const char *name, int value)
{
    sym_t *entry;
    
    entry = (sym_t *) malloc (sizeof(sym_t));
    
    entry->name = strdup(name);
    entry->val = value;
}

void
symtable_insert (const char *sym_name, int value)
{
    sym_t *entry = symtable_construct_entry (sym_name, value);
    entry->next = NULL;
    
    if (!sym_table) {
        sym_table = entry;
    }
    else {
        sym_t *currp;
        
        currp = sym_table;
        
        while (currp->next) {
            currp = currp->next;
        }
        
        currp->next = entry;
    }
}

static
sym_t*
symtable_search (const char *name)
{
    sym_t *currp;
    
    currp = sym_table;
    
    while (currp) {
        if (!strcmp (currp->name, name))
            return currp;
    }
    
    return NULL;
}

int
symtable_symbol_by_name(int *val, const char *name)
{
    sym_t *sym_pt;
    
    sym_pt = symtable_search (name);
    
    if (!sym_pt)
        return SYMT_FAILED;
    
    *val = sym_pt->val;
    return SYMT_SUCCESS;
}

int
symtable_exists (const char *name)
{
    return symtable_search(name) != NULL;
}

int
symtable_update (const char *name, int newval)
{
    sym_t *currp;
    
    currp = symtable_search(name);
    
    if (!currp)
    {
        return SYMT_FAILED;
    }
    
    currp->val = newval;
    return SYMT_SUCCESS;
}