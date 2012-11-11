Presentations
=============

Bunch of presentations created in **hieroglyph** sphinx extension.

Build instructions
------------------

::

    >>> virtualenv --no-site-packages --python=python2.7 presentations
    >>> python setup.py develop
    >>> phinx-build -b slides sourcedir outdir

slides_to_pdf.sh
----------------

**slides_to_pdf.sh** to pdf allows you convert hieroglyph slides
to pdf documents, by rendering them using **cutycapt** to images
and then converting those images to pdf. 
