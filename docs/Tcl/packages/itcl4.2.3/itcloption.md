# NAME

itcl::option - define options for extendedclass, widget or widgetadaptor

Parts of this description are \"borrowed\" from Tcl extension \[snit\],
as the functionality is mostly identical.

# WARNING!

This is new functionality in \[incr Tcl\] where the API can still
change!!

# SYNOPSIS

    option optionSpec ?defaultValue?
    option optionSpec ?options?

# DESCRIPTION

The **option** command is used inside an **\[incr Tcl\]**
extendedclass/widget/widgetadaptor definition to define options.

In the first form defines an option for instances of this type, and
optionally gives it an initial value. The initial value defaults to the
empty string if no defaultValue is specified.

An option defined in this way is said to be locally defined. The
optionSpec is a list defining the option\'s name, resource name, and
class name, e.g.:

        option {-font font Font} {Courier 12}

The option name must begin with a hyphen, and must not contain any upper
case letters. The resource name and class name are optional; if not
specified, the resource name defaults to the option name, minus the
hyphen, and the class name defaults to the resource name with the first
letter capitalized. Thus, the following statement is equivalent to the
previous example:

        option -font {Courier 12}

See The Tk Option Database for more information about resource and class
names.

Options are normally set and retrieved using the standard instance
methods configure and cget; within instance code (method bodies, etc.),
option values are available through the options array:

        set myfont $itcl_options(-font)

In the second form you can define option handlers (e.g.,
-configuremethod), then it should probably use configure and cget to
access its options to avoid subtle errors.

The option statement may include the following options:

**-default** *defvalue*

:   Defines the option\'s default value; the option\'s default value
    will be \"\" otherwise.

**-readonly**

:   The option is handled read-only \-- it can only be set using
    configure at creation time, i.e., in the type\'s constructor.

**-cgetmethod** *methodName*

:   Every locally-defined option may define a -cgetmethod; it is called
    when the option\'s value is retrieved using the cget method.
    Whatever the method\'s body returns will be the return value of the
    call to cget.

    The named method must take one argument, the option name. For
    example, this code is equivalent to (though slower than) Itcl\'s
    default handling of cget:

                option -font -cgetmethod GetOption
                method GetOption {option} {
                    return $itcl_options($option)
                }

    Note that it\'s possible for any number of options to share a
    -cgetmethod.

**-cgetmethodvar** *varName*

:   That is very similar to -cgetmethod, the only difference is, one can
    define a variable, where to find the cgetmethod during runtime.

**-configuremethod** *methodName*

:   Every locally-defined option may define a -configuremethod; it is
    called when the option\'s value is set using the configure or
    configurelist methods. It is the named method\'s responsibility to
    save the option\'s value; in other words, the value will not be
    saved to the itcl_options() array unless the method saves it there.

    The named method must take two arguments, the option name and its
    new value. For example, this code is equivalent to (though slower
    than) Itcl\'s default handling of configure:

                option -font -configuremethod SetOption
                method SetOption {option value} {
                    set itcl_options($option) $value
                }

    Note that it\'s possible for any number of options to share a single
    -configuremethod.

**-configuremethodvar** *varName*

:   That is very similar to -configuremethod, the only difference is,
    one can define a variable, where to find the configuremethod during
    runtime.

**-validatemethod** *methodName*

:   Every locally-defined option may define a -validatemethod; it is
    called when the option\'s value is set using the configure or
    configurelist methods, just before the -configuremethod (if any). It
    is the named method\'s responsibility to validate the option\'s new
    value, and to throw an error if the value is invalid.

    The named method must take two arguments, the option name and its
    new value. For example, this code verifies that -flag\'s value is a
    valid Boolean value:

                option -font -validatemethod CheckBoolean
                method CheckBoolean {option value} {
                    if {![string is boolean -strict $value]} {
                        error "option $option must have a boolean value."
                    }
                }

    Note that it\'s possible for any number of options to share a single
    -validatemethod.

**-validatemethodvar** *varName*

:   That is very similar to -validatemethod, the only difference is, one
    can define a variable, where to find the validatemethod during
    runtime.

# KEYWORDS

option, widget, widgetadaptor, extendedclass
