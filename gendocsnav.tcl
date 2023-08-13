#!/usr/bin/env tclsh

package require nx

nx::Class create nav {
    :property {rootDir "./site"}
    :property {nav_list ""}

    :method init {} {
        append :nav_list "<div id=\"docs_nav\">\n"
        append :nav_list "<ul>\n"
        : findAllHtml ${:rootDir}
        append :nav_list "</ul>\n"
        append :nav_list "</div>"
        puts ${:nav_list}
    }
    
    :method findAllHtml {dir} {
        # Check if directory contains an index.html
        if {[file exists "$dir/index.html"]} {
            append :nav_list "<li>[file tail $dir]\n"
            append :nav_list "<ul>\n"
            
            # Add the index.html to the list
            append :nav_list "<li><a href=\"$dir/index.html\">index.html</a></li>\n"
        }

        # Get subdirectories
        foreach subDir [glob -nocomplain -directory $dir *] {
            if {[file isdirectory $subDir]} {
                : findAllHtml $subDir
            }
        }

        if {[file exists "$dir/index.html"]} {
            append :nav_list "</ul>\n"
            append :nav_list "</li>\n"
        }
    }
}


# Define the FolderTreeGenerator class
nx::Class create FolderTreeGenerator {
    :property {nav_list ""}
	
    # Explicitly public method to generate the folder tree
    # :public method generate {rootDir} {
		# append :nav_list "<div id=\"docs_nav\">\n"
        # append :nav_list [:generateFolderTree $rootDir]
		# append :nav_list "</div>"
		# puts ${:nav_list}
    # }

    # Explicitly public method to generate the folder tree
    :public method generate {rootDir} {
		append :nav_list "<div id=\"docs_nav\">\n"
        return [:generateFolderTree $rootDir $rootDir]
		append :nav_list "</div>"
		puts ${:nav_list}
    }


    # Private method to recursively traverse and generate the folder tree
    :method generateFolderTree {dir rootDir} {
        set output "<ul>\n"

        # List all the folders and files in the current directory
        foreach item [glob -nocomplain -types {d f} $dir/*] {
            set itemName [file tail $item]

            # Check if the item is a directory
            if {[file isdirectory $item]} {
                # Recursively generate tree for subfolders and files
                set subTree [:generateFolderTree $item $rootDir]
                append output "<li>$itemName$subTree</li>\n"
            } else {
                if {[string match "*.html" $itemName]} {
					# ignore index.html files
					if {$itemName ne "index.html"} {
						# Calculate the relative path
						set relativePath [file join $rootDir [string replace $item 0 [string length $rootDir]-1]]
						append output "<li data-jstree='{\"icon\":\"jstree-file\"}'><a href=\"$relativePath\">$itemName</a></li>\n"
					}
                } else {
                    append output "<li>$itemName</li>\n"
                }
            }
        }

        append output "</ul>\n"
        return $output
    }
}

# Usage
set generator [FolderTreeGenerator new]
set rootDir "./site/"
puts [$generator generate $rootDir]
$generator destroy

