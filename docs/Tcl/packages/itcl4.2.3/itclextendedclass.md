# NAME

itcl::extendedclass - create a extendedclass of objects

# WARNING!

This is new functionality in \[incr Tcl\] where the API can still
change!!

# SYNOPSIS

    itcl::extendedclass extendedclassName {
        inherit baseExtendedclass ?baseExtendedclass...?
        constructor args ?init? body
        destructor body
        public method name ?args? ?body?
        protected method name ?args? ?body?
        private method name ?args? ?body?
        public proc name ?args? ?body?
        protected proc name ?args? ?body?
        private proc name ?args? ?body?
        public variable varName ?init? ?config?
        protected variable varName ?init? ?config?
        private variable varName ?init? ?config?
        public common varName ?init?
        protected common varName ?init?
        private common varName ?init?

        public command ?arg arg ...?
        protected command ?arg arg ...?
        private command ?arg arg ...?

        <delegation info> see delegation page

        <option info> see option page

        set varName ?value?
        array option ?arg arg ...?
    }

    extendedclassName objName ?arg arg ...?

    objName method ?arg arg ...?

    extendedclassName::proc ?arg arg ...?

# DESCRIPTION

The fundamental construct in **\[incr Tcl\]** is the extendedclass
definition. Each extendedclass acts as a template for actual objects
that can be created. The extendedclass itself is a namespace which
contains things common to all objects. Each object has its own unique
bundle of data which contains instances of the \"variables\" defined in
the extendedclass definition. Each object also has a built-in variable
named \"this\", which contains the name of the object. Extendedclasses
can also have \"common\" data members that are shared by all objects in
a extendedclass.

Two types of functions can be included in the extendedclass definition.
\"Methods\" are functions which operate on a specific object, and
therefore have access to both \"variables\" and \"common\" data members.
\"Procs\" are ordinary procedures in the extendedclass namespace, and
only have access to \"common\" data members.

If the body of any method or proc starts with \"**@**\", it is treated
as the symbolic name for a C procedure. Otherwise, it is treated as a
Tcl code script. See below for details on registering and using C
procedures.

A extendedclass can only be defined once, although the bodies of
extendedclass methods and procs can be defined again and again for
interactive debugging. See the **body** and **configbody** commands for
details.

Each namespace can have its own collection of objects and
extendedclasses. The list of extendedclasses available in the current
context can be queried using the \"**itcl::find extendedclasses**\"
command, and the list of objects, with the \"**itcl::find objects**\"
command.

A extendedclass can be deleted using the \"**delete extendedclass**\"
command. Individual objects can be deleted using the \"**delete
object**\" command.

# CLASS DEFINITIONS

**extendedclass** *extendedclassName definition*

:   Provides the definition for a extendedclass named
    *extendedclassName*. If the extendedclass *extendedclassName*
    already exists, or if a command called *extendedclassName* exists in
    the current namespace context, this command returns an error. If the
    extendedclass definition is successfully parsed, *extendedclassName*
    becomes a command in the current context, handling the creation of
    objects for this extendedclass.

The extendedclass *definition* is evaluated as a series of Tcl
statements that define elements within the extendedclass. The following
extendedclass definition commands are recognized:

> **inherit** *baseExtendedclass* ?*baseExtendedclass*\...?
>
> :   Causes the current extendedclass to inherit characteristics from
>     one or more base extendedclasses. Extendedclasses must have been
>     defined by a previous **extendedclass** command, or must be
>     available to the auto-loading facility (see \"AUTO-LOADING\"
>     below). A single extendedclass definition can contain no more than
>     one **inherit** command.
>
>     The order of *baseExtendedclass* names in the **inherit** list
>     affects the name resolution for extendedclass members. When the
>     same member name appears in two or more base extendedclasses, the
>     base extendedclass that appears first in the **inherit** list
>     takes precedence. For example, if extendedclasses \"Foo\" and
>     \"Bar\" both contain the member \"x\", and if another
>     extendedclass has the \"**inherit**\" statement:
>
>         inherit Foo Bar
>
>     then the name \"x\" means \"Foo::x\". Other inherited members
>     named \"x\" must be referenced with their explicit name, like
>     \"Bar::x\".
>
> **constructor** *args* ?*init*? *body*
>
> :   Declares the *args* argument list and *body* used for the
>     constructor, which is automatically invoked whenever an object is
>     created.
>
>     Before the *body* is executed, the optional *init* statement is
>     used to invoke any base extendedclass constructors that require
>     arguments. Variables in the *args* specification can be accessed
>     in the *init* code fragment, and passed to base extendedclass
>     constructors. After evaluating the *init* statement, any base
>     extendedclass constructors that have not been executed are invoked
>     automatically without arguments. This ensures that all base
>     extendedclasses are fully constructed before the constructor
>     *body* is executed. By default, this scheme causes constructors to
>     be invoked in order from least- to most-specific. This is exactly
>     the opposite of the order that extendedclasses are reported by the
>     **info heritage** command.
>
>     If construction is successful, the constructor always returns the
>     object name-regardless of how the *body* is defined-and the object
>     name becomes a command in the current namespace context. If
>     construction fails, an error message is returned.
>
> **destructor** *body*
>
> :   Declares the *body* used for the destructor, which is
>     automatically invoked when an object is deleted. If the destructor
>     is successful, the object data is destroyed and the object name is
>     removed as a command from the interpreter. If destruction fails,
>     an error message is returned and the object remains.
>
> When an object is destroyed, all destructors in its extendedclass
> hierarchy are invoked in order from most- to least-specific. This is
> the order that the extendedclasses are reported by the \"**info
> heritage**\" command, and it is exactly the opposite of the default
> constructor order.

**method** *name* ?*args*? ?*body*?

:   Declares a method called *name*. When the method *body* is executed,
    it will have automatic access to object-specific variables and
    common data members.

    If the *args* list is specified, it establishes the usage
    information for this method. The **body** command can be used to
    redefine the method body, but the *args* list must match this
    specification.

    Within the body of another extendedclass method, a method can be
    invoked like any other command-simply by using its name. Outside of
    the extendedclass context, the method name must be prefaced an
    object name, which provides the context for the data that it
    manipulates. Methods in a base extendedclass that are redefined in
    the current extendedclass, or hidden by another base extendedclass,
    can be qualified using the \"*extendedclassName*::*method*\" syntax.

**proc** *name* ?*args*? ?*body*?

:   Declares a proc called *name*. A proc is an ordinary procedure
    within the extendedclass namespace. Unlike a method, a proc is
    invoked without referring to a specific object. When the proc *body*
    is executed, it will have automatic access only to common data
    members.

    If the *args* list is specified, it establishes the usage
    information for this proc. The **body** command can be used to
    redefine the proc body, but the *args* list must match this
    specification.

    Within the body of another extendedclass method or proc, a proc can
    be invoked like any other command-simply by using its name. In any
    other namespace context, the proc is invoked using a qualified name
    like \"*extendedclassName***::***proc*\". Procs in a base
    extendedclass that are redefined in the current extendedclass, or
    hidden by another base extendedclass, can also be accessed via their
    qualified name.

**variable** *varName* ?*init*? ?*config*?

:   Defines an object-specific variable named *varName*. All
    object-specific variables are automatically available in
    extendedclass methods. They need not be declared with anything like
    the **global** command.

    If the optional *init* string is specified, it is used as the
    initial value of the variable when a new object is created.
    Initialization forces the variable to be a simple scalar value;
    uninitialized variables, on the other hand, can be set within the
    constructor and used as arrays.

    The optional *config* script is only allowed for public variables.
    If specified, this code fragment is executed whenever a public
    variable is modified by the built-in \"configure\" method. The
    *config* script can also be specified outside of the extendedclass
    definition using the **configbody** command.

**common** *varName* ?*init*?

:   Declares a common variable named *varName*. Common variables reside
    in the extendedclass namespace and are shared by all objects
    belonging to the extendedclass. They are just like global variables,
    except that they need not be declared with the usual **global**
    command. They are automatically visible in all extendedclass methods
    and procs.

    If the optional *init* string is specified, it is used as the
    initial value of the variable. Initialization forces the variable to
    be a simple scalar value; uninitialized variables, on the other
    hand, can be set with subsequent **set** and **array** commands and
    used as arrays.

    Once a common data member has been defined, it can be set using
    **set** and **array** commands within the extendedclass definition.
    This allows common data members to be initialized as arrays. For
    example:

        itcl::extendedclass Foo {
            common boolean
            set boolean(true) 1
            set boolean(false) 0
        }

    Note that if common data members are initialized within the
    constructor, they get initialized again and again whenever new
    objects are created.

**public** *command* ?*arg arg \...*?

:   

**protected** *command* ?*arg arg \...*?

:   

**private** *command* ?*arg arg \...*?

:   These commands are used to set the protection level for
    extendedclass members that are created when *command* is evaluated.
    The *command* is usually **method**, **proc**, **variable**
    or**common**, and the remaining *arg*\'s complete the member
    definition. However, *command* can also be a script containing many
    different member definitions, and the protection level will apply to
    all of the members that are created.

# CLASS USAGE

Once a extendedclass has been defined, the extendedclass name can be
used as a command to create new objects belonging to the extendedclass.

*extendedclassName objName* ?*args\...*?

:   Creates a new object in extendedclass *extendedclassName* with the
    name *objName*. Remaining arguments are passed to the constructor of
    the most-specific extendedclass. This in turn passes arguments to
    base extendedclass constructors before invoking its own body of
    commands. If construction is successful, a command called *objName*
    is created in the current namespace context, and *objName* is
    returned as the result of this operation. If an error is encountered
    during construction, the destructors are automatically invoked to
    free any resources that have been allocated, the object is deleted,
    and an error is returned.

    If *objName* contains the string \"**#auto**\", that string is
    replaced with an automatically generated name. Names have the form
    *extendedclassName\<number\>*, where the *extendedclassName* part is
    modified to start with a lowercase letter. In extendedclass
    \"Toaster\", for example, the \"**#auto**\" specification would
    produce names like toaster0, toaster1, etc. Note that \"**#auto**\"
    can be also be buried within an object name:

        fileselectiondialog .foo.bar.#auto -background red

    This would generate an object named
    \".foo.bar.fileselectiondialog0\".

# OBJECT USAGE

Once an object has been created, the object name can be used as a
command to invoke methods that operate on the object.

*objName method* ?*args\...*?

:   Invokes a method named *method* on an object named *objName*.
    Remaining arguments are passed to the argument list for the method.
    The method name can be \"constructor\", \"destructor\", any method
    name appearing in the extendedclass definition, or any of the
    following built-in methods.

# BUILT-IN METHODS

*objName* **cget option**

:   Provides access to public variables as configuration options. This
    mimics the behavior of the usual \"cget\" operation for Tk widgets.
    The *option* argument is a string of the form \"**-***varName*\",
    and this method returns the current value of the public variable
    *varName*.

*objName* **configure** ?*option*? ?*value option value \...*?

:   Provides access to public variables as configuration options. This
    mimics the behavior of the usual \"configure\" operation for Tk
    widgets. With no arguments, this method returns a list of lists
    describing all of the public variables. Each list has three
    elements: the variable name, its initial value and its current
    value.

    If a single *option* of the form \"**-***varName*\" is specified,
    then this method returns the information for that one variable.

    Otherwise, the arguments are treated as *option*/*value* pairs
    assigning new values to public variables. Each variable is assigned
    its new value, and if it has any \"config\" code associated with it,
    it is executed in the context of the extendedclass where it was
    defined. If the \"config\" code generates an error, the variable is
    set back to its previous value, and the **configure** method returns
    an error.

*objName* **isa** *extendedclassName*

:   Returns non-zero if the given *extendedclassName* can be found in
    the object\'s heritage, and zero otherwise.

*objName* **info** *option* ?*args\...*?

:   Returns information related to a particular object named *objName*,
    or to its extendedclass definition. The *option* parameter includes
    the following things, as well as the options recognized by the usual
    Tcl \"info\" command:

    *objName* **info extendedclass**

    :   Returns the name of the most-specific extendedclass for object
        *objName*.

    *objName* **info inherit**

    :   Returns the list of base extendedclasses as they were defined in
        the \"**inherit**\" command, or an empty string if this
        extendedclass has no base extendedclasses.

    *objName* **info heritage**

    :   Returns the current extendedclass name and the entire list of
        base extendedclasses in the order that they are traversed for
        member lookup and object destruction.

    *objName* **info function** ?*cmdName*? ?**-protection**? ?**-type**? ?**-name**? ?**-args**? ?**-body**?

    :   With no arguments, this command returns a list of all
        extendedclass methods and procs. If *cmdName* is specified, it
        returns information for a specific method or proc. If no flags
        are specified, this command returns a list with the following
        elements: the protection level, the type (method/proc), the
        qualified name, the argument list and the body. Flags can be
        used to request specific elements from this list.

    *objName* **info variable** ?*varName*? ?**-protection**? ?**-type**? ?**-name**? ?**-init**? ?**-value**? ?**-config**?

    :   With no arguments, this command returns a list of all
        object-specific variables and common data members. If *varName*
        is specified, it returns information for a specific data member.
        If no flags are specified, this command returns a list with the
        following elements: the protection level, the type
        (variable/common), the qualified name, the initial value, and
        the current value. If *varName* is a public variable, the
        \"config\" code is included on this list. Flags can be used to
        request specific elements from this list.

# CHAINING METHODS/PROCS

Sometimes a base extendedclass has a method or proc that is redefined
with the same name in a derived extendedclass. This is a way of making
the derived extendedclass handle the same operations as the base
extendedclass, but with its own specialized behavior. For example,
suppose we have a Toaster extendedclass that looks like this:

    itcl::extendedclass Toaster {
        variable crumbs 0
        method toast {nslices} {
            if {$crumbs > 50} {
                error "== FIRE! FIRE! =="
            }
            set crumbs [expr {$crumbs+4*$nslices}]
        }
        method clean {} {
            set crumbs 0
        }
    }

We might create another extendedclass like SmartToaster that redefines
the \"toast\" method. If we want to access the base extendedclass
method, we can qualify it with the base extendedclass name, to avoid
ambiguity:

    itcl::extendedclass SmartToaster {
        inherit Toaster
        method toast {nslices} {
            if {$crumbs > 40} {
                clean
            }
            return [Toaster::toast $nslices]
        }
    }

Instead of hard-coding the base extendedclass name, we can use the
\"chain\" command like this:

    itcl::extendedclass SmartToaster {
        inherit Toaster
        method toast {nslices} {
            if {$crumbs > 40} {
                clean
            }
            return [chain $nslices]
        }
    }

The chain command searches through the extendedclass hierarchy for a
slightly more generic (base extendedclass) implementation of a method or
proc, and invokes it with the specified arguments. It starts at the
current extendedclass context and searches through base extendedclasses
in the order that they are reported by the \"info heritage\" command. If
another implementation is not found, this command does nothing and
returns the null string.

# AUTO-LOADING

Extendedclass definitions need not be loaded explicitly; they can be
loaded as needed by the usual Tcl auto-loading facility. Each directory
containing extendedclass definition files should have an accompanying
\"tclIndex\" file. Each line in this file identifies a Tcl procedure or
**\[incr Tcl\]** extendedclass definition and the file where the
definition can be found.

For example, suppose a directory contains the definitions for
extendedclasses \"Toaster\" and \"SmartToaster\". Then the \"tclIndex\"
file for this directory would look like:

    # Tcl autoload index file, version 2.0 for [incr Tcl]
    # This file is generated by the "auto_mkindex" command
    # and sourced to set up indexing information for one or
    # more commands.  Typically each line is a command that
    # sets an element in the auto_index array, where the
    # element name is the name of a command and the value is
    # a script that loads the command.

    set auto_index(::Toaster) "source $dir/Toaster.itcl"
    set auto_index(::SmartToaster) "source $dir/SmartToaster.itcl"

The **auto_mkindex** command is used to automatically generate
\"tclIndex\" files.

The auto-loader must be made aware of this directory by appending the
directory name to the \"auto_path\" variable. When this is in place,
extendedclasses will be auto-loaded as needed when used in an
application.

# C PROCEDURES

C procedures can be integrated into an **\[incr Tcl\]** extendedclass
definition to implement methods, procs, and the \"config\" code for
public variables. Any body that starts with \"**@**\" is treated as the
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
**CrtCommand** man page for details. Within the procedure, extendedclass
data members can be accessed like ordinary variables using
**Tcl_SetVar()**, **Tcl_GetVar()**, **Tcl_TraceVar()**, etc.
Extendedclass methods and procs can be executed like ordinary commands
using **Tcl_Eval()**. **\[incr Tcl\]** makes this possible by
automatically setting up the context before executing the C procedure.

This scheme provides a natural migration path for code development.
Extendedclasses can be developed quickly using Tcl code to implement the
bodies. An entire application can be built and tested. When necessary,
individual bodies can be implemented with C code to improve performance.

# KEYWORDS

extendedclass, object, object-oriented
