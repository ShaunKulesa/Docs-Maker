\

# NAME

tdbc - Tcl Database Connectivity

# SYNOPSIS

    package require tdbc 1.0
    package require tdbc::driver version

    tdbc::driver::connection create db ?-option value...?

\

# DESCRIPTION

Tcl Database Connectivity (TDBC) is a common interface for Tcl programs
to access SQL databases. It is implemented by a series of database
*drivers*: separate modules, each of which adapts Tcl to the interface
of one particular database system. All of the drivers implement a common
series of commands for manipulating the database. These commands are all
named dynamically, since they all represent objects in the database
system. They include **connections,** which represent connections to a
database; **statements,** which represent SQL statements, and **result
sets,** which represent the sets of rows that result from executing
statements. All of these have manual pages of their own, listed under
**SEE ALSO**.

In addition, TDBC itself has a few service procedures that are chiefly
of interest to driver writers. **SEE ALSO** also enumerates them.

# SEE ALSO

Tdbc_Init(3), tdbc::connection(n), tdbc::mapSqlState(n),
tdbc::resultset(n), tdbc::statement(n), tdbc::tokenize(n),
tdbc::mysql(n), tdbc::odbc(n), tdbc::postgres(n), tdbc::sqlite3(n)

# KEYWORDS

TDBC, SQL, database, connectivity, connection, resultset, statement

# COPYRIGHT

Copyright (c) 2008 by Kevin B. Kenny.
