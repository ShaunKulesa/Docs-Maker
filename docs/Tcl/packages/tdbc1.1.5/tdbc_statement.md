\

# NAME

tdbc::statement - TDBC statement object

# SYNOPSIS

    package require tdbc 1.0
    package require tdbc::driver version

    tdbc::driver::connection create db ?-option value...?

    set stmt [db prepare sql-code]
    set stmt [db preparecall call]

    $stmt params
    $stmt paramtype ?direction? type ?precision? ?scale?
    $stmt execute ?dict?
    $stmt resultsets

*\$stmt* **allrows** ?**-as lists\|dicts**? ?**-columnsvariable**
*name*? ?**\--**? ?*dict*\

*\$stmt* **foreach** ?**-as lists\|dicts**? ?**-columnsvariable**
*name*? ?**\--**? *varName* ?*dict*? *script*\

*\$stmt* **close**

\

# DESCRIPTION

Every database driver for TDBC (Tcl DataBase Connectivity) implements a
*statement* object that represents a SQL statement in a database.
Instances of this object are created by executing the **prepare** or
**preparecall** object command on a database connection.

The **prepare** object command against the connection accepts arbitrary
SQL code to be executed against the database. The SQL code may contain
*bound* variables, which are strings of alphanumeric characters or
underscores (the first character of the string may not be numeric),
prefixed with a colon (**:**). If a bound variable appears in the SQL
statement, and is not in a string set off by single or double quotes,
nor in a comment introduced by **\--**, it becomes a value that is
substituted when the statement is executed. A bound variable becomes a
single value (string or numeric) in the resulting statement. *Drivers
are responsible for ensuring that the mechanism* for binding variables
prevents SQL injection.

The **preparecall** object command against the connection accepts a
stylized statement in the form:

>     procname (?:varname? ?,:varname...?)

or

>     varname = procname (?:varname? ?,:varname...?)

This statement represents a call to a stored procedure *procname* in the
database. The variable name to the left of the equal sign (if present),
and all variable names that are parameters inside parentheses, become
bound variables.

The **params** method against a statement object enumerates the bound
variables that appear in the statement. The result returned from the
**params** method is a dictionary whose keys are the names of bound
variables (listed in the order in which the variables first appear in
the statement), and whose values are dictionaries. The subdictionaries
include at least the following keys (database drivers may add additional
keys that are not in this list).

direction

:   Contains one of the keywords, **in**, **out** or **inout** according
    to whether the variable is an input to or output from the statement.
    Only stored procedure calls will have **out** or **inout**
    parameters.

type

:   Contains the data type of the column, and will generally be chosen
    from the set, **bigint**, **binary**, **bit**, **char**, **date**,
    **decimal**, **double**, **float**, **integer**, **longvarbinary**,
    **longvarchar**, **numeric**, **real**, **time**, **timestamp**,
    **smallint**, **tinyint**, **varbinary**, and **varchar**. (If the
    variable has a type that cannot be represented as one of the above,
    **type** will contain a driver-dependent description of the type.)

precision

:   Contains the precision of the column in bits, decimal digits, or the
    width in characters, according to the type.

scale

:   Contains the scale of the column (the number of digits after the
    radix point), for types that support the concept.

nullable

:   Contains 1 if the column can contain NULL values, and 0 otherwise.

The **paramtype** object command allows the script to specify the type
and direction of parameter transmission of a variable in a statement.
(Some databases provide no method to determine this information
automatically and place the burden on the caller to do so.) The
*direction*, *type*, *precision*, *scale*, and *nullable* arguments have
the same meaning as the corresponding dictionary values in the
**params** object command.

The **execute** object command executes the statement. Prior to
executing the statement, values are provided for the bound variables
that appear in it. If the *dict* parameter is supplied, it is searched
for a key whose name matches the name of the bound variable. If the key
is present, its value becomes the substituted variable. If not, the
value of the substituted variable becomes a SQL NULL. If the *dict*
parameter is *not* supplied, the **execute** object command searches for
a variable in the caller\'s scope whose name matches the name of the
bound variable. If one is found, its value becomes the bound variable\'s
value. If none is found, the bound variable is assigned a SQL NULL as
its value. Once substitution is finished, the resulting statement is
executed. The return value is a result set object (see
**tdbc::resultset** for details).

The **resultsets** method returns a list of all the result sets that
have been returned by executing the statement and have not yet been
closed.

The **allrows** object command executes the statement as with the
**execute** object command, accepting an optional *dict* parameter
giving bind variables. After executing the statement, it uses the
*allrows* object command on the result set (see **tdbc::resultset**) to
construct a list of the results. Finally, the result set is closed. The
return value is the list of results.

The **foreach** object command executes the statement as with the
**execute** object command, accepting an optional *dict* parameter
giving bind variables. After executing the statement, it uses the
*foreach* object command on the result set (see **tdbc::resultset**) to
evaluate the given *script* for each row of the results. Finally, the
result set is closed, even if the given *script* results in a
**return**, an error, or an unusual return code.

The **close** object command removes a statement and any result sets
that it has created. All system resources associated with the objects
are freed.

# EXAMPLES

The following code would look up a telephone number in a directory,
assuming an appropriate SQL schema:

>     package require tdbc::sqlite3
>     tdbc::sqlite3::connection create db phonebook.sqlite3
>     set statement [db prepare {
>         select phone_num from directory
>         where first_name = :firstname and last_name = :lastname
>     }]
>     set firstname Fred
>     set lastname Flintstone
>     $statement foreach row {
>         puts [dict get $row phone_num]
>     }
>     $statement close
>     db close

# SEE ALSO

encoding(n), tdbc(n), tdbc::connection(n), tdbc::resultset(n),
tdbc::tokenize(n)

# KEYWORDS

TDBC, SQL, database, connectivity, connection, resultset, statement,
bound variable, stored procedure, call

# COPYRIGHT

Copyright (c) 2008 by Kevin B. Kenny.
