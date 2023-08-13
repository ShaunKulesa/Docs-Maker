proc relTo {targetfile currentpath} {
    set cc [file split [file normalize $currentpath]]
    set tt [file split [file normalize $targetfile]]
    if {![string equal [lindex $cc 0] [lindex $tt 0]]} {
        # not on *n*x then
        return -code error "$targetfile not on same volume as $currentpath"
    }
    while {[string equal [lindex $cc 0] [lindex $tt 0]] && [llength $cc] > 0} {
        # discard matching components from the front
        set cc [lreplace $cc 0 0]
        set tt [lreplace $tt 0 0]
    }
    set prefix {} 
    if {[llength $cc] == 0} {
        # just the file name, so targetfile is lower down (or in same place)
        set prefix .
    }
    # step up the tree
    for {set i 0} {$i < [llength $cc]} {incr i} {
        append prefix { ..}
    }
    # stick it all together
    file join {*}$prefix {*}$tt
}

puts [relTo "./docs/Tk/Tk-Commands" "./docs/User-Commands"]