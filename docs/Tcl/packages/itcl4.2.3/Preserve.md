# NAME

Itcl_Alloc, Itcl_Free, Itcl_PreserveData, Itcl_ReleaseData,
Itcl_EventuallyFree - Manipulate an Itcl list object.

# SYNOPSIS

    #include <itcl.h>

    void *
    Itcl_Alloc(size)

    void
    Itcl_PreserveData(ptr)

    void
    Itcl_ReleaseData(ptr)

    void
    Itcl_EventuallyFree(ptr, fproc)

    void
    Itcl_Free(ptr)

# ARGUMENTS

Number of bytes to allocate.

Pointer value allocated by **Itcl_Alloc**.

Address of function to call when the block is to be freed.

# DESCRIPTION

These procedures are used to allocate and release memory, especially
blocks of memory that will be used by multiple independent modules. They
are similar in function to the routines in the public Tcl interface,
**Tcl_Alloc**, **Tcl_Free**, **Tcl_Preserve**, **Tcl_Release**, and
**Tcl_EventuallyFree**. The Tcl routines suffer from issues with
performance scaling as the number of blocks managed grows large. The
facilities of Itcl encounter these performance scaling issues and
require an alternative that does not suffer from them.

**Itcl_Alloc** returns an untyped pointer to an allocated block of
memory of at least *size* bytes. All *size* bytes are initialized to
zero.

A module calls **Itcl_PreserveData** on a pointer *ptr* allocated by
**Itcl_Alloc** to prevent deallocation of that memory while the module
remains interested in it.

A module calls **Itcl_ReleaseData** on a pointer *ptr* previously
preserved by **Itcl_PreserveData** to indicate the module no longer has
an interest in the block of memory, and will not be disturbed by its
deallocation.

**Itcl_EventuallyFree** is called on a pointer *ptr* allocated by
**Itcl_Alloc** to register a deallocation routine *fproc* to be called
when the number of calls to **Itcl_ReleaseData** on *ptr* matches the
number of calls to **Itcl_PreserveData** on *ptr*. This condition
indicates all modules have ended their interest in the block of memory
and a call to *fproc* with argument *ptr* will deallocate the memory
that no module needs anymore.

**Itcl_Free** is a deallocation routine for a *ptr* value allocated by
**Itcl_Alloc**. It may be called on any *ptr* with no history of an
**Itcl_PreserveData** call unmatched by an **Itcl_ReleaseData** call. It
is best used as an *fproc* argument to **Itcl_EventuallyFree** or as a
routine called from within such an *fproc* routine. It can also be used
to deallocate a *ptr* value when it can be assured that value has never
been passed to **Itcl_PreserveData** or **Itcl_EventuallyFree**.

# KEYWORDS

free, memory
