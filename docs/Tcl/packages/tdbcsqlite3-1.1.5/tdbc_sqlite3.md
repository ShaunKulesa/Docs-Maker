\

# NAME

tdbc::sqlite3 - TDBC driver for the SQLite3 database manager

# SYNOPSIS

package require **tdbc::sqlite3 1.0**

**tdbc::sqlite3::connection create** *db* *fileName* ?*-option
value\...*?

\

# DESCRIPTION

The **tdbc::sqlite3** driver provides a database interface that conforms
to Tcl DataBase Connectivity (TDBC) and allows a Tcl script to connect
to a SQLite3 database. It is also provided as a worked example of how to
write a database driver in Tcl, so that driver authors have a starting
point for further development.

Connection to a SQLite3 database is established by invoking
**tdbc::sqlite3::connection create**, passing it a string to be used as
the connection handle followed by the file name of the database. The
side effect of **tdbc::sqlite3::connection** create is to create a new
database connection.. As an alternative, **tdbc::sqlite::connection
new** may be used to create a database connection with an automatically
assigned name. The return value from **tdbc::sqlite::connection new** is
the name that was chosen for the connection handle. See
**tdbc::connection(n)** for the details of how to use the connection to
manipulate a database.

# CONFIGURATION OPTIONS

The standard configuration options **-encoding**, **-isolation**,
**-readonly** and **-timeout** are all recognized, both on
**tdbc::sqlite3::connection create** and on the **configure** method of
the resulting connection.

Since the encoding of a SQLite3 database is always well known, the
**-encoding** option accepts only **utf-8** as an encoding and always
returns **utf-8** for an encoding. The actual encoding may be set using
a SQLite3 **PRAGMA** statement when creating a new database.

Only the isolation levels **readuncommitted** and **serializable** are
implemented. Other isolation levels are promoted to **serializable**.

The **-readonly** flag is not implemented. **-readonly 0** is accepted
silently, while **-readonly 1** reports an error.

# BUGS

If any column name is not unique among the columns in a result set, the
results of **-as dicts** returns will be missing all but the rightmost
of the duplicated columns. This limitation can be worked around by
adding appropriate **AS** clauses to **SELECT** statements to ensure
that all returned column names are unique. Plans are to fix this bug by
using a C implementation of the driver, which will also improve
performance significantly.

# SEE ALSO

tdbc(n), tdbc::connection(n), tdbc::resultset(n), tdbc::statement(n)

# KEYWORDS

TDBC, SQL, SQLite3, database, connectivity, connection

# COPYRIGHT

Copyright (c) 2008 by Kevin B. Kenny.
