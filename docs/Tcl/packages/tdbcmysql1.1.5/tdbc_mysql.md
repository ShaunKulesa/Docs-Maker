\

# NAME

tdbc::mysql - TDBC-MYSQL bridge

# SYNOPSIS

package require **tdbc::mysql 1.0**

**tdbc::mysql::connection create** *db* ?*-option value\...*?\
**tdbc::mysql::connection new** ?*-option value\...*?

**tdbc::mysql::datasources** ?**-system**\|**-user**?

**tdbc::mysql::drivers**

**tdbc::mysql::datasource** *command* *driverName*
?*keyword*-*value*?\...

\

# DESCRIPTION

The **tdbc::mysql** driver provides a database interface that conforms
to Tcl DataBase Connectivity (TDBC) and allows a Tcl script to connect
to a MySQL database.

Connection to an MYSQL database is established by invoking
**tdbc::mysql::connection create**, passing it the name to give the
database handle and a set of *-option-value* pairs. The available
options are enumerated under CONNECTION OPTIONS below. As an
alternative, **tdbc::mysql::connection new** may be used to create a
database connection with an automatically assigned name. The return
value from **tdbc::mysql::connection new** is the name that was chosen
for the connection handle.

The side effect of **tdbc::mysql::connection create** is to create a new
database connection.. See **tdbc::connection(n)** for the details of how
to use the connection to manipulate a database.

# CONNECTION OPTIONS

The **tdbc::mysql::connection create** object command supports the
**-encoding**, **-isolation**, **-readonly** and **-timeout** options
common to all TDBC drivers. The **-encoding** option will always fail
unless the encoding is **utf-8**; the database connection always uses
UTF-8 encoding to be able to transfer arbitrary Unicode characters. The
**-readonly** option must be **0**, because MySQL does not offer
read-only connections.

In addition, the following options are recognized:

-host hostname

:   Connects to the host specified by *hostname*. This option must be
    set on the initial creation of the connection; it cannot be changed
    after connecting. Default is to connect to the local host.

-port number

:   Connects to a MySQL server listening on the port specified by
    *number*. This option may not be changed after connecting. It is
    used only when *host* is specified and is not **localhost**.

-socket path

:   Connects to a MySQL server listening on the Unix socket or named
    pipe specified by *path* . This option may not be changed after
    connecting. It is used only when *-host* is not specified or is
    **localhost**.

-user name

:   Presents *name* as the user name to the MySQL server. Default is the
    current user ID.

-passwd password

:   

-password password

:   These two options are synonymous. They present the given *password*
    as the user\'s password to the MySQL server. Default is not to
    present a password.

-database name

:   

-db name

:   These two options are synonymous. They present the given *name* as
    the name of the default database to use in MySQL queries. If not
    specified, the default database for the current user is used.

-interactive flag

:   The *flag* value must be a Boolean value. If it is **true** (or any
    equivalent), the default timeout is set for an interactive user,
    otherwise, the default timeout is set for a batch user. This option
    is meaningful only on initial connection. When using the
    **configure** method on a MySQL connection use the **-timeout**
    option to set the timeout desired.

-ssl_ca

:   

-ssl_capath

:   

-ssl_cert

:   

-ssl_cipher

:   

-ssl_key

:   These five options set the certificate authority, certificate
    authority search path, SSL certificate, transfer cipher, and SSL key
    to the given *string* arguments. These options may be specified only
    on initial connection to a database, not in the **configure** method
    of an existing connection. Default is not to use SSL.

# EXAMPLES

>     tdbc::mysql::connection -user joe -passwd sesame -db joes_database

Connects to the MySQL server on the local host using the default
connection method, presenting user ID \'joe\' and password \'sesame\'.
Uses \'joes_database\' as the default database name.

# ADDITIONAL CONNECTION METHODS

In addition to the usual methods on the tdbc::connection(n) object,
connections to a MySQL database support one additional method:

\$connection evaldirect sqlStatement

:   This method takes the given *sqlStatement* and interprets as MySQL
    native SQL code and evaluates it without preparing it. The statement
    may not contain variable substitutions. The result set is returned
    as a list of lists, with each sublist being the list of columns of a
    result row formatted as character strings. Note that the string
    formatting is done by MySQL and not by Tcl, so details like the
    appearance of floating point numbers may differ. *This command is
    not recommended* for anything where the usual *prepare* or
    *preparecall* methods work correctly. It is provided so that data
    management language statements that are not implemented in MySQL\'s
    prepared statement API, such as **CREATE DATABASE** or **CREATE
    PROCEDURE**, can be executed.

# SEE ALSO

tdbc(n), tdbc::connection(n), tdbc::resultset(n), tdbc::statement(n)

# KEYWORDS

TDBC, SQL, MySQL, database, connectivity, connection

# COPYRIGHT

Copyright (c) 2009 by Kevin B. Kenny.
