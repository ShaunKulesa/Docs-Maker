# NAME

Itcl_CreateObject, Itcl_DeleteObject, Itcl_FindObject, Itcl_IsObject,
Itcl_IsObjectIsa - Manipulate an class instance.

# SYNOPSIS

    #include <itclInt.h>

    void
    Itcl_PreserveData(cdata)

    void
    Itcl_ReleaseData(cdata)

    void
    Itcl_EventuallyFree(cdata, fproc)

# ARGUMENTS

Address of function to call when the block is to be freed.

Arbitrary one-word value.

# DESCRIPTION

# KEYWORDS

free, memory
