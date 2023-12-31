\

# NAME

tdbc::postgres - TDBC-POSTGRES bridge

# SYNOPSIS

package require **tdbc::postgres 1.0**

**tdbc::postgres::connection create** *db* ?*-option value\...*?\
**tdbc::postgres::connection new** ?*-option value\...*?

\

# DESCRIPTION

The **tdbc::postgres** driver provides a database interface that
conforms to Tcl DataBase Connectivity (TDBC) and allows a Tcl script to
connect to a Postgres database.

Connection to a POSTGRES database is established by invoking
**tdbc::postgres::connection create**, passing it the name to give the
database handle and a set of *-option-value* pairs. The available
options are enumerated under CONNECTION OPTIONS below. As an
alternative, **tdbc::postgres::connection new** may be used to create a
database connection with an automatically assigned name. The return
value from **tdbc::postgres::connection new** is the name that was
chosen for the connection handle.

The side effect of **tdbc::postgres::connection create** is to create a
new database connection.. See **tdbc::connection(n)** for the details of
how to use the connection to manipulate a database.

# CONNECTION OPTIONS

The **tdbc::postgres::connection create** object command supports the
**-encoding**, **-isolation**, **-readonly** and **-timeout** options
common to all TDBC drivers. The **-timeout** option will only affect
connection process, once connected this value will be ignored and cannot
be changed after connecting.

In addition, the following options are recognized (these options must be
set on the initial creation of the connection; they cannot be changed
after connecting) :

-host hostname

:   Connects to the host specified by *hostname*. Default is to connect
    using a local Unix domain socket.

-hostaddr address

:   Connects to the host specified by given IP *address*. If both
    **-host** and **-hostaddr** are given, the value of **-host** is
    ignored. Default is to connect using a local Unix domain socket.

-port number

:   Connects to a Postgres server listening on the port specified by
    *number*. It is used only when *host* or *hostaddr* is specified.

-user name

:   Presents *name* as the user name to the Postgres server. Default is
    the current user ID.

-passwd password

:   

-password password

:   These two options are synonymous. They present the given *password*
    as the user\'s password to the Postgres server. Default is not to
    present a password.

-database name

:   

-db name

:   These two options are synonymous. They present the given *name* as
    the name of the default database to use in Postgres queries. If not
    specified, the default database for the current user is used.

-options opts

:   This sets *opts* as additional command line options send to the
    server.

-tty file

:   This option is ignored on never servers. Formerly this specified
    where to send debug output. This option is left for compatibility
    with older servers.

-sslmode mode

:   This option determines whether or with what priority an SSL
    connection will be negotiated with the server. There are four
    *modes*: **disable** will attempt only an unencrypted SSL
    connection; **allow** will negotiate, trying first a non-SSL
    connection, then if that fails, trying an SSL connection; **prefer**
    (the default) will negotiate, trying first an SSL connection, then
    if that fails, trying a regular non-SSL connection; **require** will
    try only an SSL connection. If PostgreSQL is compiled without SSL
    support, using option **require** will cause an error, and options
    **allow** and **prefer** will be tolerated but the driver will be
    unable to negotiate an SSL connection.

-requiressl

:   This option is deprecated in favor of the **-sslmode** setting. The
    *flag* value must be a Boolean value. If it is **true** (or any
    equivalent), driver will then refuse to connect if the server does
    not accept an SSL connection. The default value is **false** (or any
    equivalent), and acts the same like **-sslmode** **preffered**

-service

:   It specifies a service *name* in pg_service.conf file that holds
    additional connection parameters. This allows applications to
    specify only a service name so connection parameters can be
    centrally maintained. Refer to PostgreSQL Documentation or
    PREFIX/share/pg_service.conf.sample file for details.

# EXAMPLES

>     tdbc::postgres::connection -user joe -passwd sesame -db joes_database

Connects to the Postgres server on the local host using the default
connection method, presenting user ID \'joe\' and password \'sesame\'.
Uses \'joes_database\' as the default database name.

# SEE ALSO

tdbc(n), tdbc::connection(n), tdbc::resultset(n), tdbc::statement(n)

# KEYWORDS

TDBC, SQL, Postgres, database, connectivity, connection

# COPYRIGHT

Copyright (c) 2009 by Slawomir Cygan
