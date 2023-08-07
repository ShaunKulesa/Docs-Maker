# NAME

Itcl_InitStack, Itcl_DeleteStack, Itcl_PushStack, Itcl_PopStack,
Itcl_PeekStack, Itcl_GetStackValue, Itcl_GetStackSize - Manipulate an
Itcl stack object.

# SYNOPSIS

    #include <itcl.h>

    int
    Itcl_InitStack(stack)

    int
    Itcl_DeleteStack(stack)

    int
    Itcl_PushStack(cdata, stack)

    ClientData
    Itcl_PopStack(stack)

    ClientData
    Itcl_PeekStack(stack)

    ClientData
    Itcl_GetStackValue(stack, pos)

    int
    Itcl_GetStackSize(stack)

# ARGUMENTS

Stack info structure.

position in stack order from the top.

Arbitrary one-word value to save in the stack.

# DESCRIPTION

**Itcl_InitStack** initializes a stack structure and
**Itcl_DeleteStack** deletes it. **Itcl_PushStack** pushes the *cdata*
value onto the stack. **Itcl_PopStack** removes and returns the top most
*cdata* value. **Itcl_PeekStack** returns the top most value, but does
not remove it. **Itcl_GetStackValue** gets a value at some index within
the stack. Index \"0\" is the first value pushed onto the stack.
**Itcl_GetStackSize** returns the count of entries on the stack.

# KEYWORDS

stack
