\

# NAME

tdbc::connection - TDBC connection object

# SYNOPSIS

    package require tdbc 1.0
    package require tdbc::driver version

    tdbc::driver::connection create db ?-option value...?

    db configure ?-option value...?
    db close
    db foreignkeys ?-primary tableName? ?-foreign tableName?
    db prepare sql-code
    db preparecall call
    db primarykeys tableName
    db statements
    db resultsets
    db tables ?pattern?
    db columns table ?pattern?
    db begintransaction
    db commit
    db rollback
    db transaction script

*db* **allrows** ?**-as lists**\|**dicts**? ?**-columnsvariable**
*name*? ?**\--**? *sql-code* ?*dictionary*?\

*db* **foreach** ?**-as lists**\|**dicts**? ?**-columnsvariable**
*name*? ?\--? *varName sqlcode* ?*dictionary*? *script*

\

# DESCRIPTION

Every database driver for TDBC (Tcl DataBase Connectivity) implements a
*connection* object that represents a connection to a database. By
convention, this object is created by the command,
**tdbc::***driver***::connection create**. This command accepts the name
of a Tcl command that will represent the connection and a possible set
of options (see **CONFIGURATION** OPTIONS). It establishes a connection
to the database and returns the name of the newly-created Tcl command.

The **configure** object command on a database connection, if presented
with no arguments, returns a list of alternating keywords and values
representing the connection\'s current configuration. If presented with
a single argument *-option*, it returns the configured value of the
given option. Otherwise, it must be given an even number of arguments
which are alternating options and values. The specified options receive
the specified values, and nothing is returned.

The **close** object command on a database connection closes the
connection. All active statements and result sets on the connection are
closed. Any uncommitted transaction is rolled back. The object command
is deleted.

The **prepare** object command on a database connection prepares a SQL
statement for execution. The *sql-code* argument must contain a single
SQL statement to be executed. Bound variables may be included. The
return value is a newly-created Tcl command that represents the
statement. See **tdbc::statement** for more detailed discussion of the
SQL accepted by the **prepare** object command and the interface
accepted by a statement.

On a database connection where the underlying database and driver
support stored procedures, the **preparecall** object command prepares a
call to a stored procedure for execution. The syntax of the stored
procedure call is:

?*resultvar* =? *procname*(?*arg* ?, *arg*\...?)

The return value is a newly-created Tcl command that represents the
statement. See **tdbc::statement** for the interface accepted by a
statement.

The **statements** object command returns a list of statements that have
been created by **prepare** and **preparecall** statements against the
given connection and have not yet been closed.

The **resultsets** object command returns a list of result sets that
have been obtained by executing statements prepared using the given
connection and not yet closed.

The **tables** object command allows the program to query the connection
for the names of tables that exist in the database. The optional
*pattern* parameter is a pattern to match the name of a table. It may
contain the SQL wild-card characters \'**%**\' and and whose values are
subdictionaries. See the documentation for the individual database
driver for the interpretation of the values.

The **columns** object command allows the program to query the
connection for the names of columns that exist in a given table. The
optional **pattern** parameter is a pattern to match the name of a
column. It may contain the SQL wild-card characters \'**%**\' and and
whose values are dictionaries. Each of the subdictionaries will contain
at least the following keys and values (and may contain others whose
usage is determined by a specific database driver).

type

:   Contains the data type of the column, and will generally be chosen
    from the set, **bigint**, **binary**, **bit**, **char**, **date**,
    **decimal**, **double**, **float**, **integer**, **longvarbinary**,
    **longvarchar**, **numeric**, **real**, **time**, **timestamp**,
    **smallint**, **tinyint**, **varbinary**, and **varchar**. (If the
    column has a type that cannot be represented as one of the above,
    **type** will contain a driver-dependent description of the type.)

precision

:   Contains the precision of the column in bits, decimal digits, or the
    width in characters, according to the type.

scale

:   Contains the scale of the column (the number of digits after the
    radix point), for types that support the concept.

nullable

:   Contains 1 if the column can contain NULL values, and 0 otherwise.

The **primarykeys** object command allows the program to query the
connection for the primary keys belonging to a given table. The
*tableName* parameter identifies the table being interrogated. The
result is a list of dictionaries enumerating the keys (in a similar
format to the list returned by *\$connection* **allrows -as dicts**).
The keys of the dictionary may include at least the following. Values
that are NULL or meaningless in a given database are omitted.

tableCatalog

:   Name of the catalog in which the table appears.

tableSchema

:   Name of the schema in which the table appears.

tableName

:   Name of the table owning the primary key.

constraintCatalog

:   Name of the catalog in which the primary key constraint appears. In
    some database systems, this may not be the same as the table\'s
    catalog.

constraintSchema

:   Name of the schema in which the primary key constraint appears. In
    some database systems, this may not be the same as the table\'s
    schema.

constraintName

:   Name of the primary key constraint,

columnName

:   Name of a column that is a member of the primary key.

ordinalPosition

:   Ordinal position of the column within the primary key.

To these columns may be added additional ones that are specific to a
particular database system.

The **foreignkeys** object command allows the program to query the
connection for foreign key relationships that apply to a particular
table. The relationships may be constrained to the keys that appear in a
particular table (**-foreign** *tableName*), the keys that refer to a
particular table (**-primary** *tableName*), or both. At least one of
**-primary** and **-foreign** should be specified, although some drivers
will enumerate all foreign keys in the current catalog if both options
are omitted. The result of the **foreignkeys** object command is a list
of dictionaries, with one list element per key (in a similar format to
the list returned by *\$connection* **allrows -as dicts**). The keys of
the dictionary may include at least the following. Values that are NULL
or meaningless in a given database are omitted.

foreignConstraintCatalog

:   Catalog in which the foreign key constraint appears.

foreignConstraintSchema

:   Schema in which the foreign key constraint appears.

foreignConstraintName

:   Name of the foreign key constraint.

primaryConstraintCatalog

:   Catalog holding the primary key constraint (or unique key
    constraint) on the column to which the foreign key refers.

primaryConstraintSchema

:   Schema holding the primary key constraint (or unique key constraint)
    on the column to which the foreign key refers.

primaryConstraintName

:   Name of the primary key constraint (or unique key constraint) on the
    column to which the foreign key refers.

updateAction

:   Action to take when an UPDATE statement invalidates the constraint.
    The value will be **CASCADE**, **SET DEFAULT**, **SET NULL**,
    **RESTRICT**, or **NO ACTION**.

deleteAction

:   Action to take when a DELETE statement invalidates the constraint.
    The value will be **CASCADE**, **SET DEFAULT**, **SET NULL**,
    **RESTRICT**, or **NO ACTION**.

primaryCatalog

:   Catalog name in which the primary table (the one to which the
    foreign key refers) appears.

primarySchema

:   Schema name in which the primary table (the one to which the foreign
    key refers) appears.

```{=html}
<!-- -->
```

primaryTable

:   Table name of the primary table (the one to which the foreign key
    refers).

primaryColumn

:   Name of the column to which the foreign key refers.

foreignCatalog

:   Name of the catalog in which the table containing the foreign key
    appears.

foreignSchema

:   Name of the schema in which the table containing the foreign key
    appears.

foreignTable

:   Name of the table containing the foreign key.

foreignColumn

:   Name of the column appearing in the foreign key.

ordinalPosition

:   Position of the column in the foreign key, if the key is a compound
    key.

The **begintransaction** object command on a database connection begins
a transaction on the database. If the underlying database does not
support atomic, consistent, isolated, durable transactions, the
**begintransaction** object command returns an error reporting the fact.
Similarly, if multiple **begintransaction** commands are executed
withough an intervening **commit** or **rollback** command, an error is
returned unless the underlying database supports nested transactions.

The **commit** object command on a database connection ends the most
recent transaction started by **begintransaction** and commits changes
to the database.

The **rollback** object command on a database connection rolls back the
most recent transaction started by **begintransaction**. The state of
the database is as if nothing happened during the transaction.

The **transaction** object command on a database connection presents a
simple way of bundling a database transaction. It begins a transaction,
and evaluates the supplied *script* argument as a Tcl script in the
caller\'s scope. If *script* terminates normally, or by **break**,
**continue**, or **return**, the transaction is committed (and any
action requested by **break**, **continue**, or **return** takes place).
If the commit fails for any reason, the error in the commit is treated
as an error in the *script*. In the case of an error in *script* or in
the commit, the transaction is rolled back and the error is rethrown.
Any nonstandard return code from the script causes the transaction to be
rolled back and then is rethrown.

The **allrows** object command prepares a SQL statement (given by the
*sql-code* parameter) to execute against the database. It then executes
it (see **tdbc::statement** for details) with the optional *dictionary*
parameter giving bind variables. Finally, it uses the *allrows* object
command on the result set (see **tdbc::resultset**) to construct a list
of the results. Finally, both result set and statement are closed. The
return value is the list of results.

The **foreach** object command prepares a SQL statement (given by the
*sql-code* parameter) to execute against the database. It then executes
it (see **tdbc::statement** for details) with the optional *dictionary*
parameter giving bind variables. Finally, it uses the *foreach* object
command on the result set (see **tdbc::resultset**) to evaluate the
given *script* for each row of the results. Finally, both result set and
statement are closed, even if the given *script* results in a
**return**, an error, or an unusual return code.

# CONFIGURATION OPTIONS

The configuration options accepted when the connection is created and on
the connection\'s **configure** object command include the following,
and may include others specific to a database driver.

-encoding name

:   Specifies the encoding to be used in connecting to the database. The
    *name* should be one of the names accepted by the **encoding**
    command. This option is usually unnecessary; most database drivers
    can figure out the encoding in use by themselves.

-isolation level

:   Specifies the transaction isolation level needed for transactions on
    the database. The acceptable values for *level* are shown under
    **TRANSACTION ISOLATION LEVELS**.

-timeout ms

:   Specifies the maximum time to wait for a an operation database
    engine before reporting an error to the caller. The *ms* argument
    gives the maximum time in milliseconds. A value of zero (the
    default) specifies that the calling process is to wait indefinitely
    for database operations.

-readonly flag

:   Specifies that the connection will not modify the database (if the
    Boolean parameter *flag* is true), or that it may modify the
    database (if *flag* is false). If *flag* is true, this option may
    have the effect of raising the transaction isolation level to
    *readonly*.

## TRANSACTION ISOLATION LEVELS

The acceptable values for the **-isolation** configuration option are as
follows:

readuncommitted

:   Allows the transaction to read \"dirty\", that is, uncommitted data.
    This isolation level may compromise data integrity, does not
    guarantee that foreign keys or uniqueness constraints are satisfied,
    and in general does not guarantee data consistency.

readcommitted

:   Forbids the transaction from reading \"dirty\" data, but does not
    guarantee repeatable reads; if a transaction reads a row of a
    database at a given time, there is no guarantee that the same row
    will be available at a later time in the same transaction.

repeatableread

:   Guarantees that any row of the database, once read, will have the
    same values for the life of a transaction. Still permits \"phantom
    reads\" (that is, newly-added rows appearing if a table is queried a
    second time).

serializable

:   The most restrictive (and most expensive) level of transaction
    isolation. Any query to the database, if repeated, will return
    precisely the same results for the life of the transaction, exactly
    as if the transaction is the only user of the database.

readonly

:   Behaves like **serializable** in that the only results visible to
    the transaction are those that were committed prior to the start of
    the transaction, but forbids the transaction from modifying the
    database.

A database that does not implement one of these isolation levels will
instead use the next more restrictive isolation level. If the given
level of isolation cannot be obtained, the database interface throws an
error reporting the fact. The default isolation level is
**readcommitted**.

A script should not the isolation level when a transaction is in
progress.

# SEE ALSO

encoding(n), tdbc(n), tdbc::resultset(n), tdbc::statement(n),
tdbc::tokenize(n)

# KEYWORDS

TDBC, SQL, database, connectivity, connection, resultset, statement

# COPYRIGHT

Copyright (c) 2008 by Kevin B. Kenny.
