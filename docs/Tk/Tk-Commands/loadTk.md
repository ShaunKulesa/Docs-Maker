# NAME

safe::loadTk - Load Tk into a safe interpreter.

# SYNOPSIS

**safe::loadTk** *child* ?**-use** *windowId*? ?**-display**
*displayName*?

# DESCRIPTION

Safe Tk is based on Safe Tcl, which provides a mechanism that allows
restricted and mediated access to auto-loading and packages for safe
interpreters. Safe Tk adds the ability to configure the interpreter for
safe Tk operations and load Tk into safe interpreters.

The **safe::loadTk** command initializes the required data structures in
the named safe interpreter and then loads Tk into it. The interpreter
must have been created with **safe::interpCreate** or have been
initialized with **safe::interpInit**. The command returns the name of
the safe interpreter. If **-use** is specified, the window identified by
the specified system dependent identifier *windowId* is used to contain
the window of the safe interpreter; it can be any valid id, eventually
referencing a window belonging to another application. As a convenience,
if the window you plan to use is a Tk Window of the application you can
use the window name (e.g., instead of its window Id (e.g., from **winfo
id** **.x.y**). When **-use** is not specified, a new toplevel window is
created for the window of the safe interpreter. On X11 if you want the
embedded window to use another display than the default one, specify it
with **-display**. See the **SECURITY ISSUES** section below for
implementation details.

# SECURITY ISSUES

Please read the **safe** manual page for Tcl to learn about the basic
security considerations for Safe Tcl.

**safe::loadTk** adds the value of **tk_library** taken from the parent
interpreter to the virtual access path of the safe interpreter so that
auto-loading will work in the safe interpreter.

Tk initialization is now safe with respect to not trusting the child\'s
state for startup. **safe::loadTk** registers the child\'s name so when
the Tk initialization (**Tk_SafeInit**) is called and in turn calls the
parent\'s **safe::InitTk** it will return the desired **argv**
equivalent (**-use** *windowId*, correct **-display**, etc.)

When **-use** is not used, the new toplevel created is specially
decorated so the user is always aware that the user interface presented
comes from a potentially unsafe code and can easily delete the
corresponding interpreter.

On X11, conflicting **-use** and **-display** are likely to generate a
fatal X error.

# SEE ALSO

safe(n), interp(n), library(n), load(n), package(n), source(n),
unknown(n)

# KEYWORDS

alias, auto-loading, auto_mkindex, load, parent interpreter, safe
interpreter, child interpreter, source
