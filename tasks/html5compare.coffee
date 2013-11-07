#
# * grunt-html5compare
# * https://github.com/metalshark/grunt-html5compare
# *
# * Copyright (c) 2013 'Metalshark' Beech Horn
# * Licensed under the LGPL v3 license.
#
'use strict'

module.exports = (grunt) ->

    html5compare = require('./lib/html5compare')
    path = require('path')

    compareFileGroup = (fileGroup) ->
        fileGroup.src.forEach (src) ->
            # Warn on and remove invalid source files (if nonull was set).
            srcpath = fileGroup.orig.cwd + path.sep + src
            unless grunt.file.exists(srcpath)
                grunt.log.warn 'Source file \'' + srcpath + '\' not found.'
                return false

            # Warn on and remove invalid compare (dest) files (if nonull was set).
            destpath = fileGroup.dest + path.sep + src
            unless grunt.file.exists(destpath)
                grunt.log.warn 'Compare file \'' + destpath + '\' not found.'
                return false

            if html5compare.compare srcpath, destpath
                grunt.log.ok srcpath + ' is equivalent to ' + destpath
                return true
            else
                grunt.log.warn srcpath + ' is not equivalent to ' + destpath
                return false

    # Please see the grunt documentation for more information regarding task
    # creation: https://github.com/gruntjs/grunt/blob/devel/docs/toc.md
    grunt.registerMultiTask 'html5compare', 'Compares HTML 5 files for equivalence.', ->

        # Merge task-specific and/or target-specific options with these defaults.
        options = @options()
        grunt.verbose.writeflags options, 'Options'

        # Iterate over all specified file groups.
        @files.forEach (fileGroup) ->

            fileGroup.src.forEach compareFileGroup
