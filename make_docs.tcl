# Language Tcl

# Get folders and sub-folders in .\docs
proc ::findFiles { baseDir pattern } {
    set dirs [ glob -nocomplain -type d [ file join $baseDir * ] ]
    set files {}
    foreach dir $dirs { 
        lappend files {*}[ findFiles $dir $pattern ] 
    }
    lappend files {*}[ glob -nocomplain -type f [ file join $baseDir $pattern ] ] 
    return $files

    # ./docs/category1/subcatergory1/index.md
    # ./docs/category1/index.md
    # ./docs/index.md
}

# Delete everything in ".\site\"
file delete -force ./site/

# get all css files in .\css
set css_files [ findFiles css *.css ]

# Convert markdown links to html links
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

proc see_also_links {file_path file_dict} {
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
    
    set command_index 0

    foreach command $see_also_section {
        # remove spaces
        set command [ string trim $command ]

        # remove the last 3 characters such as "(n)"
        set command [ string range $command 0 end-3 ]

        if {![dict exists $file_dict $command]} {
            incr command_index
            continue
        }

        # Add link to command
        set command "\[$command\](./[file tail [dict get $file_dict $command]])"

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

proc create_index {dir file_dict categoty_dirs} {
    # Create index.md for each dir

    set index_file_dir [ string cat $dir/index.md ]

    # Create index.md
    set index_file [ open $index_file_dir w ]

    if {[llength $categoty_dirs] > 0} {
        puts -nonewline $index_file "Catrgories\n\n"

        foreach category_dir $categoty_dirs {
            set category_name [ file tail $category_dir ]

            puts -nonewline $index_file "\[$category_name\](./[file tail $category_dir]/index.html)\n\n"
        }
    }

    if {[dict size $file_dict] > 0} {
        puts -nonewline $index_file "Commands\n\n"

        #sort the dictionary by key
        set keys [dict keys $file_dict]

        # Sort the keys using lsort
        set sortedKeys [lsort $keys]

        # Create a new dictionary with sorted keys
        set sortedDict [dict create]

        foreach key $sortedKeys {
            dict set sortedDict $key [dict get $file_dict $key]
        }

        dict for {command file_dir} $sortedDict {
            puts -nonewline $index_file "\[$command\](./[file tail $file_dir])\n\n"
        }
    }

    close $index_file
}

# Get all files in .\docs
set files [ findFiles docs *.md ]

#add empty string to the end of the list to know when to stop looping
lappend files ""

set current_dir [ file dirname [lindex $files 0] ]
# set commands [dict create]
# set category_dirs [list]

# # Create temp directory
# file mkdir ./temp/

# # Loop through markdown files
# foreach file $files {
#     # Check to see if on new directory
#     if {$current_dir != [ file dirname $file ]} {
#         create_index ./temp $commands $category_dirs

#         # Loop through temp files
#         foreach temp_file [glob ./temp/*] {
            
#             see_also_links $temp_file $commands

#             convert_links $temp_file

#             set file_site_dir [ string cat ./site/[string replace $current_dir 0 4 ""]/[string replace [ file tail $temp_file ] end-2 end ".html" ]]
            
#             exec pandoc -f markdown -t html $temp_file -o $file_site_dir

#             set cdn_file [open "./incl/docscdn" r]    ;# 'r' means to open the file for reading
# 		    set cdndata [read $cdn_file]
#             close $cdn_file
#             set dir_depth [ llength [ split $file_dir / ] ]
#             set html [ read [open $file_site_dir r] ]
#             set html [ string cat "</head><body><div class=\"container\">" $html ]

#             set html [ string cat "<link rel=\"stylesheet\" href=\"../" [ string repeat "../" $dir_depth ] "data/css/style.css\">" $html ]
#             set html [ string cat "<head> $cdndata" $html ]

#             set html [ string cat "<!DOCTYPE html>" $html ]

#             # write html to file
#             set f [ open $file_site_dir "w" ]
#             puts -nonewline $f $html
#             puts -nonewline $f "</div><script>hljs.highlightAll();</script></body></html>"
#             close $f

#         }

#         # Delete temp directory
#         file delete -force ./temp/

#         # Create temp directory
#         file mkdir ./temp/

#         set current_dir [ file dirname $file ]
#     }

#     if {$file == ""} {
#         continue
#     }

#     set file_commands [ find_commands $file [ split [ read [ open $file r ] ] "\n" ] ]

#     set commands [dict merge $commands $file_commands]



#     set file_extension [ file extension $file ]

#     if {$file_extension == ".md"} {
#         ### Find commands in files under NAME section ###

#         # Open markdown file
#         set f [ open $file r ]
#         set file_contents [ read $f ]
#         set file_lines [ split $file_contents "\n" ]

#         # set file_contents [ convert_links $file_contents ]
#         close $f

#         # Get file name and remove .md
#         set file_name [ string range [ file tail $file ] 0 end-3 ]

#         find_commands "$file_name.md" $file_lines

#         set temp_file_dir [ string cat ./temp/$file_name.md ]

#         # Create temp file
#         set temp_file [open $temp_file_dir w]
#         puts -nonewline $temp_file $file_contents
#         close $temp_file

#         # File directory - get dirname and remove docs/ at the start
#         set file_dir [ string range [ file dirname $file ] 5 end ]

#         # Create directory if the file is not in the base directory
#         if {$file_dir != ""} {
#             file mkdir [ string cat ./site/$file_dir ]
#         }
#     }
# }

# # Delete temp directory 
# file delete -force ./temp/

# {dir {files {}} {category_dirs {}}
set docs_structure [dict create]
set dir_files [list]
set dir_category_dirs [list]

# # Loop through markdown files
# foreach file $files {
#     # check if dir is in dict
#     if {[dict exists $docs_structure $current_dir] == 0} {
#         dict set docs_structure $current_dir [dict create files [list] category_dirs [list]]
#     }
        
#     if {[file dirname $file] != $current_dir} {
#         # check if current dir is a subdirectory of another already in the dict
#         set current_dir_split [split [file dirname $file] /]
#         set current_dir_split_length [llength $current_dir_split]
#         set current_dir_split_length [expr $current_dir_split_length - 1]
#         set current_dir_split [lrange $current_dir_split 0 $current_dir_split_length]
#         set current_dir_split [join $current_dir_split /]

#         puts "$current_dir_split, $docs_structure\n" 

#         if {[dict exists $docs_structure $current_dir_split]} {
#             # puts "subdir of $current_dir_split"
#             dict set docs_structure $current_dir_split files $dir_files
#             dict set docs_structure $current_dir_split category_dirs $dir_category_dirs
#         }

#         set current_dir [file dirname $file]
        
#     }

# }

# puts $docs_structure

# recursively loop through dirs and subdirs
proc loop_dirs {dir} {
    global docs_structure
    global dir_files
    global dir_category_dirs

    set files [glob $dir/*]
    set current_dir [file dirname [lindex $files 0] ]
    set dir_files [list]
    set dir_category_dirs [list]

    foreach file $files {
        if {[file isdirectory $file]} {
            loop_dirs $file
        } else {
            lappend dir_files $file
        }
    }

    dict set docs_structure $current_dir files $dir_files
    dict set docs_structure $current_dir category_dirs $dir_category_dirs
}

loop_dirs ./docs

puts $docs_structure

set commands [dict create]


