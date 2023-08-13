package require struct::tree 2.1.1
package require json

proc relTo {currentpath targetfile} {
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

proc convert_links {file_path} {
    # find a matching pair of ()
    # get the text inside the ()
    # convert .md to .html in the text

    set file [ open $file_path r ]
    set file_contents [ read $file ]
    close $file
    
    set start_index 0
    set end_index 0

    while {1} {
        set start_index [ string first "(" $file_contents $start_index ]

        if {$start_index == -1} {
            break
        }

        set end_index [ string first ")" $file_contents $start_index ]

        if {$end_index == -1} {
            break
        }

        set link_text [ string range $file_contents $start_index+1 $end_index-1 ]

        set link_text [ string map { ".md" ".html" } $link_text ]

        set file_contents [ string replace $file_contents $start_index+1 $end_index-1 $link_text ]

        incr start_index
    }
    
    # Write to file
    set file [ open $file_path w ]
    puts -nonewline $file $file_contents
    close $file
}

proc find_commands {file_name file_lines} {
    # coroutine, yield, yieldto - Create and produce values from coroutines to {coroutine file_name yield file_name yieldto file_name}

    set name_section_index -1
    set next_section_index -1

    set line_index 0

    # Creat command: file dictionary
    set file_dict [ dict create ]

    foreach line $file_lines {
        # Get index of "# NAME" section
        if {[ string match "# NAME" $line ]} {
            set name_section_index $line_index
            continue
        }

        # Get index of the next "#" section
        if {[string index $line 0] == "#" && $name_section_index != -1} {
            set next_section_index $line_index
            break
        }

        incr line_index
    }

    if {$name_section_index != -1 && $next_section_index != -1} {
        # Get the name section content
        set name_section_content [join [lrange $file_lines $name_section_index+1 $next_section_index-1] " "]

        # split using the first exisistence of " - "
        set name_section_content [lindex [ split $name_section_content "-"] 0]

        # split up commands into a list
        set commands [ split $name_section_content "," ]

        foreach command $commands {
            # remove spaces
            set command [ string trim $command ]

            # Add command to dictionary
            dict set file_dict $command $file_name
        }
    }

    return $file_dict
}

proc see_also_links {original_file file_path file_dict} {
    # SEE ALSO
    # after(n), interp(n)


    set file [ open $file_path r ]

    set file_contents [ read $file ]
    set file_lines [ split $file_contents "\n" ]
    close $file

    # Get index of "# SEE ALSO" section
    set start_index [lsearch -glob $file_lines "# SEE ALSO" ]

    # Get index of the next section
    set end_index [lsearch -start $start_index+1 -glob $file_lines "# *" ]

    set see_also_section [lrange $file_lines $start_index+1 $end_index-1]

    # Combine all lines into one string
    set see_also_section [ join $see_also_section " " ]

    # Turn each comma spearated command into a list item
    set see_also_section [ split $see_also_section "," ]

    # puts $see_also_section    
    set command_index 0

    foreach command $see_also_section {
        # remove spaces
        set command [ string trim $command ]

        #remove (n) (1) (3)
        regsub -all {\([0-9|n]\)} $command {} command

        if {![dict exists $file_dict $command]} {

            incr command_index
            continue
        }

        set command_dir [ dict get $file_dict $command ]

        set original_file_html_dir [string cat ./site/manual_pages/ [join [lrange [split [string range $original_file 7 end] "/"] 0 end-1] "/"]]
        set command_html_dir [string cat ./site/manual_pages/ [join [lrange [split [string range $command_dir 7 end] "/"] 0 end-1] "/"]]
       
        if {[relTo $original_file_html_dir $command_html_dir] == "."} {
            set relative_path [file tail $command_dir]
        } else {
            set relative_path [string cat [relTo $original_file_html_dir $command_html_dir] "/" [file tail $command_dir]]
        }

        set command "\[$command\]($relative_path)"
      
        # # Add link to command

        set see_also_section [ lreplace $see_also_section $command_index $command_index $command]

        incr command_index
    }


    set see_also_section [ join $see_also_section ", " ]

    set file_lines [ lreplace $file_lines $start_index+1 $end_index-1 "$see_also_section\n\n" ]

    set file_contents [ join $file_lines "\n" ]

    # Write to file
    set file [ open $file_path w ]
    puts $file $file_contents
    close $file
}

set dir_tree [struct::tree]
$dir_tree rename root ./docs

file delete -force ./temp/
file delete -force ./site/manual_pages/

# create temp dir
file mkdir ./temp
file mkdir ./site/manual_pages

proc tree-callback {tree node action} {
    upvar 1 commands commands
    # puts $node
    set files [glob -nocomplain -directory $node *md]

    file mkdir [file join ./site/manual_pages [string range $node 7 end]]

    set file_dict [dict get $commands $node]

    #check if config.json exists
    if {[file exists [file join $node config.json]]} {
        set config_file [open [file join $node config.json] r]
        set command_dirs [dict get [json::json2dict [read $config_file]] "command_references"]
        close $config_file



        

        foreach command_dir $command_dirs {
            # puts $command_dir
            # remove . from start of command dir and add .docs to start of command_dir
            set command_dir [string cat "./docs" [string range $command_dir 1 end]]

            # check if dir is a folder
            if {[file isdirectory $command_dir]} {
                set file_dict [dict merge $file_dict [dict get $commands $command_dir]]
                puts $node
                puts $command_dir

                
            } elseif {[file exists [file join $node $command_dir]]} {
                set command_dir [file dirname $command_dir]
            }
        }

        # puts 
    }
    

    # get parent node subnodes
    # if {$node != [ $tree rootname ]} {
        
    #     set subnodes [ $tree children [$tree parent $node] ]

    #     foreach subnode $subnodes {
    #         set file_dict [dict merge $file_dict [dict get $commands $subnode]]
    #     }
    # }
   
    # puts $file_dict
    
    # create copies of files in temp dir
    foreach file $files {
        set new_file [file join ./temp [file tail $file]]
        file copy $file $new_file

        # create see also links
        # puts $file_dict

        see_also_links $file $new_file $file_dict

        # convert links
        convert_links $new_file

        # pandoc md to html
        set html_file [file join ./site/manual_pages [string range $node 7 end] [string replace [file tail $file] end-2 end .html]]

        exec pandoc -f markdown -t html $new_file -o $html_file
    }

    # empty temp dir
    file delete -force ./temp/
    
    file mkdir ./temp
}

proc create_index {tree node action} {
    upvar 1 commands commands

    set index_file [open [file join ./site/manual_pages [string range $node 7 end] index.html] w]

    set subnodes [ $tree children $node ]

    if {[llength $subnodes] != 0} {
        puts $index_file "<h1> Categories </h1>"

        foreach category $subnodes {
            set subnode_local [lindex [split $category /] end]
            puts $index_file "<a href=\"./$subnode_local/index.html\">$subnode_local</a><br>"
        }
    }

    set command_files [dict get $commands $node]

    if {[llength $command_files] != 0} {
        puts $index_file "<h1> Commands </h1>"

        dict for {command command_file} $command_files {
            set command_file [string range [file tail $command_file] 0 end-3]
            puts $index_file "<a href=\"./$command_file.html\">$command</a><br>"
        }
    }

    close $index_file
}

proc ftw_1 {{dirs .}} {
    set subdirs {}
    while {[llength $dirs]} {
        set dirs [lassign $dirs name]
        lappend dirs {*}[glob -nocomplain -directory $name -type d *]
        lappend subdirs $name
    }

    return $subdirs
}

proc add_to_tree {tree dirs} {
    foreach dir $dirs {
        set parent [file dirname $dir]

        $tree insert $parent 0 $dir
    }
}

set dirs [ftw_1 [list ./docs]]
set dirs [lreplace $dirs 0 0]

add_to_tree $dir_tree $dirs


proc find_commands_callback {tree node action} {
    upvar 1 commands commands
    set files [glob -nocomplain -directory $node *md]

    dict set commands $node [dict create]

    foreach file_path $files {
        set file [ open $file_path r ]
        set file_lines [ split [ read $file ] "\n" ]
        close $file

        set file_dict [ find_commands $file_path $file_lines ]

        dict set commands $node [dict merge [dict get $commands $node] $file_dict]
    }
}

# todo

# walk all dirs to create a dictionary of dirs and their {commands: files}

set commands [dict create]

$dir_tree walkproc ./docs -order post -type bfs find_commands_callback

$dir_tree walkproc ./docs -order post -type bfs tree-callback

$dir_tree walkproc ./docs -order post -type bfs create_index
