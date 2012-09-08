Description
===========

Styed preview of markdown files in browser or PDF viewer.

Installation
============

    $ gem install mdprev

For PDF support, download [http://code.google.com/p/wkhtmltopdf/] and copy it
into your `/path/to/bin/wkhtmltopdf`.  Or you can configure `mdprev` to use
another program.  Here's an example of what to stick in your `bashrc` or
`zshrc`:

    MDPREV_CONVERT_PDF = 'htmldoc --webpage -f $output $input'

`$output` will be replcaed with the full path to the PDF name.  `$input`
will be replaced with an HTML document filename.

You can configure which command to use preview HTML/PDF files.  By default it's 
`open` which works fine on OS X.  For example usage with XFCE's `thunar`, just
add these environment variables in your `bashrc` or `zshrc`:

    MDPREV_OPEN_HTML = 'thunar'
    MDPREV_OPEN_PDF  = 'thunar'

Usage
=====

    mdprev file1.md file2.md
    mdprev file1.md file2.md --nav
    mdprev file1.md --pdf

TODO
====

* switch default to htmldoc
* use htmldoc's page break system with h1s

License
=======

Copyright (c) Hugh Bien, http://hughbien.com.

Released under BSD License, see LICENSE.md for more info.
