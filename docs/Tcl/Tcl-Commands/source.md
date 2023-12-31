# NAME

source - Evaluate a file or resource as a Tcl script

# SYNOPSIS

**source** *fileName*

**source** **-encoding** *encodingName fileName*

# DESCRIPTION

This command takes the contents of the specified file or resource and
passes it to the Tcl interpreter as a text script. The return value from
**source** is the return value of the last command executed in the
script. If an error occurs in evaluating the contents of the script then
the **source** command will return that error. If a **return** command
is invoked from within the script then the remainder of the file will be
skipped and the **source** command will return normally with the result
from the **return** command.

The end-of-file character for files is (\^Z) for all platforms. The
source command will read files up to this character. This restriction
does not exist for the **read** or **gets** commands, allowing for files
containing code and data segments (scripted documents). If you require a
in code for string comparison, you can use or which will be safely
substituted by the Tcl interpreter into

A leading BOM (Byte order mark) contained in the file is ignored for
unicode encodings (utf-8, unicode).

The **-encoding** option is used to specify the encoding of the data
stored in *fileName*. When the **-encoding** option is omitted, the
system encoding is assumed.

# EXAMPLE

Run the script in the file **foo.tcl** and then the script in the file
**bar.tcl**:

    source foo.tcl
    source bar.tcl

Alternatively:

    foreach scriptFile {foo.tcl bar.tcl} {
        source $scriptFile
    }

# SEE ALSO

file(n), cd(n), encoding(n), info(n)

# KEYWORDS

file, script
