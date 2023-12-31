# NAME

Tcl_UpVar, Tcl_UpVar2 - link one variable to another

# SYNOPSIS

    #include <tcl.h>

    int
    Tcl_UpVar(interp, frameName, sourceName, destName, flags)

    int
    Tcl_UpVar2(interp, frameName, name1, name2, destName, flags)

# ARGUMENTS

Interpreter containing variables; also used for error reporting.

Identifies the stack frame containing source variable. May have any of
the forms accepted by the **upvar** command, such as **#0** or **1**.

Name of source variable, in the frame given by *frameName*. May refer to
a scalar variable or to an array variable with a parenthesized index.

Name of destination variable, which is to be linked to source variable
so that references to *destName* refer to the other variable. Must not
currently exist except as an upvar-ed variable.

One of **TCL_GLOBAL_ONLY**, **TCL_NAMESPACE_ONLY** or 0; if non-zero,
then *destName* is a global or namespace variable; otherwise it is local
to the current procedure (or current namespace if no procedure is
active).

First part of source variable\'s name (scalar name, or name of array
without array index).

If source variable is an element of an array, gives the index of the
element. For scalar source variables, is NULL.

# DESCRIPTION

**Tcl_UpVar** and **Tcl_UpVar2** provide the same functionality as the
**upvar** command: they make a link from a source variable to a
destination variable, so that references to the destination are passed
transparently through to the source. The name of the source variable may
be specified either as a single string such as **xyx** or **a(24)** (by
calling **Tcl_UpVar**) or in two parts where the array name has been
separated from the element name (by calling **Tcl_UpVar2**). The
destination variable name is specified in a single string; it may not be
an array element.

Both procedures return either **TCL_OK** or **TCL_ERROR**, and they
leave an error message in the interpreter\'s result if an error occurs.

As with the **upvar** command, the source variable need not exist; if it
does exist, unsetting it later does not destroy the link. The
destination variable may exist at the time of the call, but if so it
must exist as a linked variable.

# KEYWORDS

linked variable, upvar, variable
