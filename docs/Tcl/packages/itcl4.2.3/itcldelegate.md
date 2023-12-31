# NAME

itcl::delegation - delegate methods, procs or options to other objects

Parts of this description are \"borrowed\" from Tcl extension \[snit\],
as the functionality is mostly identical.

# WARNING!

This is new functionality in \[incr Tcl\] where the API can still
change!!

# SYNOPSIS

    delegate method methodName to componentName ?as targetName?
    delegate method methodName ?to componentName? using pattern
    delegate method * ?to componentName? ?using pattern? ?except methodName methodName ...?

    delegate proc procName to componentName ?as targetName?
    delegate proc procName ?to componentName? using pattern
    delegate proc * ?to componentName? ?using pattern? ?except procName procName ...?

    delegate option optionSpec to componentName
    delegate option optionSpec to componentName as targetname?
    delegate option * to componentName
    delegate option * to componentName except optionName optionname ...

# DESCRIPTION

The **delegate** command is used inside an **\[incr Tcl\]**
extendedclass/widget/widgetadaptor definition to delegate
methods/procs/options to other objects for handling.

**delegate method** *methodName* **to** *componentName* ?**as** *targetName*?

:   This form of delegate method delegates method methodName to
    component componentName. That is, when method methdoNameame is
    called on an instance of this type, the method and its arguments
    will be passed to the named component\'s command instead. That is,
    the following statement

        delegate method wag to tail

    is roughly equivalent to this explicitly defined method:

        method wag {args} {
            uplevel $tail wag $args
        }

    The optional **as** clause allows you to specify the delegated
    method name and possibly add some arguments:

        delegate method wagtail to tail as "wag briskly"

    A method cannot be both locally defined and delegated.

**delegate method** *methodName* ?**to** *componentName*? **using** *pattern*

:   In this form of the delegate statement, the **using** clause is used
    to specify the precise form of the command to which method name name
    is delegated. The **to** clause is optional, since the chosen
    command might not involve any particular component.

    The value of the using clause is a list that may contain any or all
    of the following substitution codes; these codes are substituted
    with the described value to build the delegated command prefix. Note
    that the following two statements are equivalent:

        delegate method wag to tail
        delegate method wag to tail using "%c %m"

    Each element of the list becomes a single element of the delegated
    command \--it is never reparsed as a string.

    Substitutions:

    **%%**

    :   This is replaced with a single \"%\". Thus, to pass the string
        \"%c\" to the command as an argument, you\'d write \"%%c\".

    **%c**

    :   This is replaced with the named component\'s command.

    **%j**

    :   This is replaced by the method name; if the name consists of
        multiple tokens, they are joined by underscores (\"\_\").

    **%m**

    :   This is replaced with the final token of the method name; if the
        method name has one token, this is identical to **%M**.

    **%M**

    :   This is replaced by the method name; if the name consists of
        multiple tokens, they are joined by space characters.

    **%n**

    :   This is replaced with the name of the instance\'s private
        namespace.

    **%s**

    :   This is replaced with the name of the instance command.

    **%t**

    :   This is replaced with the fully qualified type name.

    **%w**

    :   This is replaced with the original name of the instance command;
        for Itcl widgets and widget adaptors, it will be the Tk window
        name. It remains constant, even if the instance command is
        renamed.

**delegate method** *\** ?**to** *componentName*? ?**using** *pattern*? ?**except** *methodName methodName \...*?

:   In this form all unknown method names are delegeted to the specified
    component. The except clause can be used to specify a list of
    exceptions, i.e., method names that will not be so delegated. The
    using clause is defined as given above. In this form, the statement
    must contain the to clause, the using clause, or both.

    In fact, the \"\*\" can be a list of two or more tokens whose last
    element is \"\*\", as in the following example:

        delegate method {tail *} to tail

    This implicitly defines the method tail whose subcommands will be
    delegated to the tail component.

    The definitions for **delegate proc** \... are the same as for
    method, the only difference being, that this is for procs.

**delegate option** *namespec* **to** *comp*

:   

**delegate option namespec to comp as target**

:   

**delegate option \* to** *comp*

:   

**delegate option \* to** *comp* **except** *exceptions*

:   Defines a delegated option; the namespec is defined as for the
    option statement. When the configure, configurelist, or cget
    instance method is used to set or retrieve the option\'s value, the
    equivalent configure or cget command will be applied to the
    component as though the option was defined with the following
    **-configuremethod** and **-cgetmethod**:

        method ConfigureMethod {option value} {
            $comp configure $option $value
        }

        method CgetMethod {option} {
            return [$comp cget $option]
        }

    Note that delegated options never appear in the **itcl_options**
    array. If the as clause is specified, then the target option name is
    used in place of name.

**delegate** *option* **\*** ?**except** *optionName optionName \...*?

:   This form delegates all unknown options to the specified component.
    The except clause can be used to specify a list of exceptions, i.e.,
    option names that will not be so delegated.

    **Warning:** options can only be delegated to a component if it
    supports the **configure** and **cget** instance methods.

    An option cannot be both locally defined and delegated. TBD:
    Continue from here.

# KEYWORDS

delegation, option, method, proc
