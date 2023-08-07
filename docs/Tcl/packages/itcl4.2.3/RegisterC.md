# NAME

Itcl_RegisterC, Itcl_RegisterObjC, Itcl_FindC - Associate a symbolic
name with a C procedure.

# SYNOPSIS

    #include <itcl.h>

    int
    Itcl_RegisterC(interp, cmdName, argProc, clientData, deleteProc)

    int
    Itcl_RegisterObjC(interp, cmdName, objProc, clientData, deleteProc)

    int
    Itcl_FindC(interp, cmdName, argProcPtr, objProcPtr, cDataPtr)

# ARGUMENTS

Interpreter in which to create new command.

Name of command.

Implementation of new command: *argProc* will be called whenever

The Tcl_CmdProc \* to receive the pointer.

Implementation of the new command: *objProc* will be called whenever

The Tcl_ObjCmdProc \* to receive the pointer.

Arbitrary one-word value to pass to *proc* and *deleteProc*.

The ClientData to receive the pointer.

Procedure to call before *cmdName* is deleted from the interpreter;
allows for command-specific cleanup. If NULL, then no procedure is
called before the command is deleted.

# DESCRIPTION

Used to associate a symbolic name with an (argc,argv) C procedure that
handles a Tcl command. Procedures that are registered in this manner can
be referenced in the body of an \[incr Tcl\] class definition to specify
C procedures to acting as methods/procs. Usually invoked in an
initialization routine for an extension, called out in Tcl_AppInit() at
the start of an application.

Each symbolic procedure can have an arbitrary client data value
associated with it. This value is passed into the command handler
whenever it is invoked.

A symbolic procedure name can be used only once for a given style
(arg/obj) handler. If the name is defined with an arg-style handler, it
can be redefined with an obj-style handler; or if the name is defined
with an obj-style handler, it can be redefined with an arg-style
handler. In either case, any previous client data is discarded and the
new client data is remembered. However, if a name is redefined to a
different handler of the same style, this procedure returns an error.

Returns TCL_OK on success, or TCL_ERROR (along with an error message in
interp-\>result) if anything goes wrong.

C procedures can be integrated into an **\[incr Tcl\]** class definition
to implement methods, procs, and the \"config\" code for public
variables. Any body that starts with \"**@**\" is treated as the
symbolic name for a C procedure.

Symbolic names are established by registering procedures via
**Itcl_RegisterC()**. This is usually done in the **Tcl_AppInit()**
procedure, which is automatically called when the interpreter starts up.
In the following example, the procedure `My_FooCmd()` is registered with
the symbolic name \"foo\". This procedure can be referenced in the
**body** command as \"`@foo`\".

    int
    Tcl_AppInit(interp)
        Tcl_Interp *interp;     /* Interpreter for application. */
    {
        if (Itcl_Init(interp) == TCL_ERROR) {
            return TCL_ERROR;
        }

        if (Itcl_RegisterC(interp, "foo", My_FooCmd) != TCL_OK) {
            return TCL_ERROR;
        }
    }

C procedures are implemented just like ordinary Tcl commands. See the
**CrtCommand** man page for details. Within the procedure, class data
members can be accessed like ordinary variables using **Tcl_SetVar()**,
**Tcl_GetVar()**, **Tcl_TraceVar()**, etc. Class methods and procs can
be executed like ordinary commands using **Tcl_Eval()**. **\[incr
Tcl\]** makes this possible by automatically setting up the context
before executing the C procedure.

This scheme provides a natural migration path for code development.
Classes can be developed quickly using Tcl code to implement the bodies.
An entire application can be built and tested. When necessary,
individual bodies can be implemented with C code to improve performance.

See the Archetype class in **\[incr Tk\]** for an example of how this C
linking method is used.

# SEE ALSO

Tcl_CreateCommand, Tcl_CreateObjCommand

# KEYWORDS

class, object
