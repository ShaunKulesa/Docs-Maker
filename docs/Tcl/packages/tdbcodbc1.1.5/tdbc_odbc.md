\

# NAME

tdbc::odbc - TDBC-ODBC bridge

# SYNOPSIS

package require **tdbc::odbc 1.0**

**tdbc::odbc::connection create** *db* *connectionString* ?*-option
value\...*?\
**tdbc::odbc::connection new** *connectionString* ?*-option value\...*?

**tdbc::odbc::datasources** ?**-system**\|**-user**?

**tdbc::odbc::drivers**

**tdbc::odbc::datasource** *command* *driverName*
?*keyword*-*value*?\...

\

# DESCRIPTION

The **tdbc::odbc** driver provides a database interface that conforms to
Tcl DataBase Connectivity (TDBC) and allows a Tcl script to connect to
any SQL database presenting an ODBC interface. It is also provided as a
worked example of how to write a database driver in C, so that driver
authors have a starting point for further development.

Connection to an ODBC database is established by invoking
**tdbc::odbc::connection create**, passing it the name to be used as a
connection handle, followed by a standard ODBC connection string. As an
alternative, **tdbc::odbc::connection new** may be used to create a
database connection with an automatically assigned name. The return
value from **tdbc::odbc::connection new** is the name that was chosen
for the connection handle.

The connection string will include at least a **DRIVER** or **DSN**
keyword, and may include others that are defined by a particular ODBC
driver. (If the local ODBC system supports a graphical user interface,
the **-parent** option (see below) may allow calling
**tdbc::odbc::connection create** with an empty connection string.)

The side effect of **tdbc::odbc::connection create** is to create a new
database connection.. See **tdbc::connection(n)** for the details of how
to use the connection to manipulate a database.

In addition to a standard TDBC interface, **tdbc::odbc** supports three
additional ccommands. The first of these, **tdbc::odbc::datasources**,
which returns a Tcl list enumerating the named data sources available to
the program (for connection with the **DSN** keyword in the connection
string). The result of **tdbc::odbc::datasources** may be constrained to
only system data sources or only user data sources by including the
**-system** or **-user** options, respectively.

The **tdbc::odbc::drivers** command returns a dictionary whose keys are
the names of drivers available for the **DRIVER** keyword in the
connection string, and whose values are descriptions of the drivers.

The **tdbc::odbc::datasource** command allows configuration of named
data sources on those systems that support the ODBC Installer
application programming interface. It accepts a *command*, which
specifies the operation to be performed, the name of a *driver* for the
database in question, and a set of keyword-value pairs that are
interpreted by the given driver. The *command* must be one of the
following:

add

:   Adds a user data source. The keyword-value pairs must include at
    least a **DSN** option naming the data source

add_system

:   Adds a system data source. The keyword-value pairs must include at
    least a **DSN** option naming the data source

configure

:   Configures a user data source. The keyword-value pairs will usually
    include a **DSN** option naming the data source. Some drivers will
    support other options, such as the **CREATE_DB** option to the
    Microsoft Access driver on Windows.

configure_system

:   Configures a system data source.

remove

:   Removes a user data source. The keyword-value pairs must include a
    **DSN** option specifying the data source to remove.

remove_system

:   Removes a system data source. The keyword-value pairs must include a
    **DSN** option specifying the data source to remove.

# CONNECTION OPTIONS

The **tdbc::odbc::connection create** object command supports the
**-encoding**, **-isolation**, **-readonly** and **-timeout** options
common to all TDBC drivers. The **-encoding** option will succeed only
if the requested encoding is the same as the system encoding;
**tdbc::odbc** does not attempt to specify alternative encodings to an
ODBC driver. (Some drivers accept encoding specifications in the
connection string.)

In addition, if Tk is present in the requesting interpreter, and the
local system\'s ODBC driver manager supports a graphical user interface,
the **tdbc::odbc::connection create** object command supports a
**-parent** option, whose value is the path name of a Tk window. If this
option is specified, and a connection string does not specify all the
information needed to connect to an interface, the ODBC driver manager
will display a dialog box to request whatever additional information is
required. The requesting interpreter will block until the user dismisses
the dialog, at which point the connection is made.

# EXAMPLES

Sincs ODBC connection strings are driver specific, it is often difficult
to find the documentation needed to compose them. The following examples
are known to work on most Windows systems and provide at least a few
useful things that a program can do.

>     tdbc::odbc::connection create db \
>         "DSN={PAYROLL};UID={aladdin};PWD={Sesame}"

Connects to a named data source \"PAYROLL\", providing \"aladdin\" as a
user name and \"Sesame\" as a password. Uses **db** as the name of the
connection.

>     set connString {DRIVER={Microsoft Access Driver (*.mdb)};}
>     append connString {FIL={MS Access}\;}
>     append connString {DBQ=} \
>         [file nativename [file normalize $fileName]]
>     tdbc::odbc::connection create db2 -readonly 1 $connString

Opens a connection to a Microsoft Access database file whose name is in
*\$fileName*. The database is opened in read-only mode. The resulting
connection is called \"db2\".

>     tdbc::odbc::connection create db3 \
>         "DRIVER=SQLite3;DATABASE=$fileName"

Opens a connection to a SQLite3 database whose name is in
\"\$fileName\".

>     tdbc::odbc::datasource add \
>         {Microsoft Access Driver (*.mdb)} \
>         DSN=MyTestDatabase \
>         DBQ=[file native [file normalize $fileName]]

Creates a new user data source with the name, \"MyTestDatabase\" bound
to a Microsoft Access file whose path name is in \"\$fileName\". No
connection is made to the data source until the program calls
**tdbc::odbc::connection create**.

>     tdbc::odbc::datasource configure \
>         {Microsoft Access Driver (*.mdb)} \
>         CREATE_DB=[file native [file normalize $fileName]] \
>         General

Creates a new, empty Microsoft Access database in the file identified by
\"\$fileName\". No connection is made to the database until the program
calls **tdbc::odbc::connection create**.

# ADDITIONAL CONNECTION METHODS

In addition to the usual methods on the tdbc::connection(n) object,
connections to an ODBC database support one additional method:

\$connection

:   This method takes the given driver-native SQL code *sqlStatement*
    and evaluates it without preparing it. The statement is not
    tokenized and must not contain variable substitutions. Evaluating
    the *sqlStatement* produces a result set of zero or more rows. The
    result of the command is a list of dictionaries, with one list
    element per row in the result set (in a similar format to the list
    returned by *\$connection allrows -as dicts*). *This command is not
    recommended* for anything where the usual *prepare* or *preparecall*
    methods work correctly. It is provided so that data management
    language statements that are not implemented by the driver\'s
    prepared statement API (such as **CREATE** DATABASE or **CREATE
    PROCEDURE**), or that contain characters that are reserved by the
    tokenizer, can be executed.

# SEE ALSO

tdbc(n), tdbc::connection(n), tdbc::resultset(n), tdbc::statement(n)

# KEYWORDS

TDBC, SQL, ODBC, database, connectivity, connection

# COPYRIGHT

Copyright (c) 2008 by Kevin B. Kenny.
