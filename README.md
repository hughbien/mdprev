Description
===========

Styed preview of markdown files in browser or PDF viewer.

Installation
============

    % gem install mdprev

For PDF support, download [http://code.google.com/p/wkhtmltopdf/] and copy it
into your `/path/to/bin/wkhtmltopdf`.

You can configure which command to use preview HTML/PDF files.  By default it's 
`open` which works fine on OS X.  Just add these environment variables in your
`bashrc` or `zshrc`:

    MDPREV_OPEN_HTML = 'open'
    MDPREV_OPEN_PDF  = 'open'

Usage
=====

    mdprev file1.md file2.md
    mdprev file1.md file2.md --nav
    mdprev file1.md --pdf

License
=======

Copyright 2011 Hugh Bien, http://hughbien.com.

Released under MIT License, see LICENSE.md for more info.
