# NAME

Tk_Grab, Tk_Ungrab - manipulate grab state in an application

# SYNOPSIS

    #include <tk.h>

    int
    Tk_Grab(interp, tkwin, grabGlobal)

    void
    Tk_Ungrab(tkwin)

# ARGUMENTS

Interpreter to use for error reporting

Window on whose behalf the pointer is to be grabbed or released

Boolean indicating whether the grab is global or application local

# DESCRIPTION

These functions are used to set or release a global or application local
grab. When a grab is set on a particular window in a Tk application,
mouse and keyboard events can only be received by that window and its
descendants. Mouse and keyboard events for windows outside the tree
rooted at *tkwin* will be redirected to *tkwin*. If the grab is global,
then all mouse and keyboard events for windows outside the tree rooted
at *tkwin* (even those intended for windows in other applications) will
be redirected to *tkwin*. If the grab is application local, only mouse
and keyboard events intended for a windows within the same application
(but outside the tree rooted at *tkwin*) will be redirected.

**Tk_Grab** sets a grab on a particular window. *Tkwin* specifies the
window on whose behalf the pointer is to be grabbed. *GrabGlobal*
indicates whether the grab should be global or application local; if it
is non-zero, it means the grab should be global. Normally, **Tk_Grab**
returns **TCL_OK**; if an error occurs and the grab cannot be set,
**TCL_ERROR** is returned and an error message is left if *interp*\'s
result. Once this call completes successfully, no window outside the
tree rooted at *tkwin* will receive pointer- or keyboard-related events
until the next call to Tk_Ungrab. If a previous grab was in effect
within the application, then it is replaced with a new one.

**Tk_Ungrab** releases a grab on the mouse pointer and keyboard, if
there is one set on the window given by *tkwin*. Once a grab is
released, pointer and keyboard events will start being delivered to
other windows again.

# KEYWORDS

grab, window
