# NAME

itcl::component - define components for extendedclass, widget or
widgetadaptor

Parts of this description are \"borrowed\" from Tcl extension \[snit\],
as the functionality is mostly identical.

# WARNING!

This is new functionality in \[incr Tcl\] where the API can still
change!!

# SYNOPSIS

    public component comp ?-inherit?
    protected component comp ?-inherit?
    private component comp ?-inherit?

# DESCRIPTION

The **component** command is used inside an **\[incr Tcl\]**
extendedclass/widget/widgetadaptor definition to define components.

Explicitly declares a component called comp, and automatically defines
the component\'s instance variable.

If the *-inherit* option is specified then all unknown methods and
options will be delegated to this component. The name -inherit implies
that instances of this new type inherit, in a sense, the methods and
options of the component. That is, -inherit yes is equivalent to:

    component mycomp
    delegate option * to mycomp
    delegate method * to mycomp

# KEYWORDS

component, widget, widgetadaptor, extendedclass
