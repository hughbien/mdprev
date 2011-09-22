Description
===========

Preview HTML from markdown files.

Installation
============

    sudo gem install kramdown
    cp mdprev.rb /path/to/bin/mdprev

You can configure which command to use preview HTML files.  By default it's 
`open` which works fine on OS X.  Just change this line in `mdprev.rb`:

    OPEN_HTML = 'open'

Usage
=====

    mdprev file1.md file2.md
    mdprev file1.md file2.md --nav
    mdprev file1.md --pdf

License
=======

Copyright 2011 Hugh Bien, http://hughbien.com.

Released under MIT License, see LICENSE.md for more info.
