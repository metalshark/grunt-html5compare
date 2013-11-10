###
grunt-html5compare
https://github.com/metalshark/grunt-html5compare

Copyright (c) 2013 'Metalshark' Beech Horn
Licensed under the LGPL v3 license.
###
'use strict'

module.exports = (grunt) ->
    html5compare = require('./lib/html5compare').init()
    path = require('path')

    # Please see the grunt documentation for more information regarding task
    # creation: https://github.com/gruntjs/grunt/blob/devel/docs/toc.md
    grunt.registerMultiTask 'html5compare', 'Compares HTML 5 files for equivalence.', ->

        # Merge task-specific and/or target-specific options with these defaults.
        options = @options()
        grunt.verbose.writeflags options, 'Options'

        # Iterate over all specified file groups.
        for fileGroup in @files
            compareFileGroup fileGroup, options

    compareFileGroup = (fileGroup, options) ->
        for src in fileGroup.src
            compareSrc src, fileGroup, options

    compareSrc = (src, fileGroup, options) ->
        # Warn on and remove invalid source files (if nonull was set).
        unless grunt.file.exists(src)
            grunt.warn 'Source file \'' + src + '\' not found.'
            return false

        dest = fileGroup.dest

        # Warn on and remove invalid compare (dest) files (if nonull was set).
        unless grunt.file.exists(dest)
            grunt.warn 'Compare file \'' + dest + '\' not found.'
            return false

        origHTML = grunt.file.read src
        compHTML = grunt.file.read dest

        try
            html5compare.compare origHTML, compHTML
            message = src + ' is equivalent to ' + dest
            unless options.different
                grunt.log.ok message
            else
                grunt.error message
        catch e
            message = src + ' is not equivalent to ' + dest
            unless options.different
                grunt.error message
                grunt.error e
            else
                grunt.log.ok message
