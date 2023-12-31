# NAME

fcopy - Copy data from one channel to another

# SYNOPSIS

**fcopy** *inchan* *outchan* ?**-size** *size*? ?**-command**
*callback*?

# DESCRIPTION

The **fcopy** command copies data from one I/O channel, *inchan* to
another I/O channel, *outchan*. The **fcopy** command leverages the
buffering in the Tcl I/O system to avoid extra copies and to avoid
buffering too much data in main memory when copying large files to slow
destinations like network sockets.

The **fcopy** command transfers data from *inchan* until end of file or
*size* bytes or characters have been transferred; *size* is in bytes if
the two channels are using the same encoding, and is in characters
otherwise. If no **-size** argument is given, then the copy goes until
end of file. All the data read from *inchan* is copied to *outchan*.
Without the **-command** option, **fcopy** blocks until the copy is
complete and returns the number of bytes or characters (using the same
rules as for the **-size** option) written to *outchan*.

The **-command** argument makes **fcopy** work in the background. In
this case it returns immediately and the *callback* is invoked later
when the copy completes. The *callback* is called with one or two
additional arguments that indicates how many bytes were written to
*outchan*. If an error occurred during the background copy, the second
argument is the error string associated with the error. With a
background copy, it is not necessary to put *inchan* or *outchan* into
non-blocking mode; the **fcopy** command takes care of that
automatically. However, it is necessary to enter the event loop by using
the **vwait** command or by using Tk.

You are not allowed to do other input operations with *inchan*, or
output operations with *outchan*, during a background **fcopy**. The
converse is entirely legitimate, as exhibited by the bidirectional fcopy
example below.

If either *inchan* or *outchan* get closed while the copy is in
progress, the current copy is stopped and the command callback is *not*
made. If *inchan* is closed, then all data already queued for *outchan*
is written out.

Note that *inchan* can become readable during a background copy. You
should turn off any **fileevent** handlers during a background copy so
those handlers do not interfere with the copy. Any wrong-sided I/O
attempted (by a **fileevent** handler or otherwise) will get a error.

**Fcopy** translates end-of-line sequences in *inchan* and *outchan*
according to the **-translation** option for these channels. See the
manual entry for **fconfigure** for details on the **-translation**
option. The translations mean that the number of bytes read from
*inchan* can be different than the number of bytes written to *outchan*.
Only the number of bytes written to *outchan* is reported, either as the
return value of a synchronous **fcopy** or as the argument to the
callback for an asynchronous **fcopy**.

**Fcopy** obeys the encodings and character translations configured for
the channels. This means that the incoming characters are converted
internally first UTF-8 and then into the encoding of the channel
**fcopy** writes to. See the manual entry for **fconfigure** for details
on the **-encoding** and **-translation** options. No conversion is done
if both channels are set to encoding and have matching translations. If
only the output channel is set to encoding the system will write the
internal UTF-8 representation of the incoming characters. If only the
input channel is set to encoding the system will assume that the
incoming bytes are valid UTF-8 characters and convert them according to
the output encoding. The behaviour of the system for bytes which are not
valid UTF-8 characters is undefined in this case.

# EXAMPLES

The first example transfers the contents of one channel exactly to
another. Note that when copying one file to another, it is better to use
**file copy** which also copies file metadata (e.g. the file access
permissions) where possible.

    fconfigure $in -translation binary
    fconfigure $out -translation binary
    fcopy $in $out

This second example shows how the callback gets passed the number of
bytes transferred. It also uses vwait to put the application into the
event loop. Of course, this simplified example could be done without the
command callback.

    proc Cleanup {in out bytes {error {}}} {
        global total
        set total $bytes
        close $in
        close $out
        if {[string length $error] != 0} {
            # error occurred during the copy
        }
    }
    set in [open $file1]
    set out [socket $server $port]
    fcopy $in $out -command [list Cleanup $in $out]
    vwait total

The third example copies in chunks and tests for end of file in the
command callback.

    proc CopyMore {in out chunk bytes {error {}}} {
        global total done
        incr total $bytes
        if {([string length $error] != 0) || [eof $in]} {
            set done $total
            close $in
            close $out
        } else {
            fcopy $in $out -size $chunk \
                    -command [list CopyMore $in $out $chunk]
        }
    }
    set in [open $file1]
    set out [socket $server $port]
    set chunk 1024
    set total 0
    fcopy $in $out -size $chunk \
            -command [list CopyMore $in $out $chunk]
    vwait done

The fourth example starts an asynchronous, bidirectional fcopy between
two sockets. Those could also be pipes from two \[open \"\|hal 9000\"
r+\] (though their conversation would remain secret to the script, since
all four fileevent slots are busy).

    set flows 2
    proc Done {dir args} {
         global flows done
         puts "$dir is over."
         incr flows -1
         if {$flows<=0} {set done 1}
    }
    fcopy $sok1 $sok2 -command [list Done UP]
    fcopy $sok2 $sok1 -command [list Done DOWN]
    vwait done

# SEE ALSO

eof(n), fblocked(n), fconfigure(n), file(n)

# KEYWORDS

blocking, channel, end of line, end of file, nonblocking, read,
translation
