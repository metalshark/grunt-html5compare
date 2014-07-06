###
grunt-html5compare
https://github.com/metalshark/grunt-html5compare

Copyright (c) 2014 'Metalshark' Beech Horn
Licensed under the LGPL v3 license.
###
'use strict'

module.exports = (grunt) ->
    html5compare = require('./lib/html5compare')
    path = require('path')

    # Please see the grunt documentation for more information regarding task
    # creation: https://github.com/gruntjs/grunt/blob/devel/docs/toc.md
    grunt.registerMultiTask 'html5compare', 'Compares HTML 5 files for equivalence.', ->

        # Merge task-specific and/or target-specific options with these defaults.
        options = @options()
        grunt.verbose.writeflags options, 'Options'

        # Iterate over all specified file groups.
        fileCount = 0

        _compareFileGroup = (fileGroup, options) ->
            for src in fileGroup.src
                _compareSrc src, fileGroup, options

        _compareSrc = (src, fileGroup, options) ->
            # Warn on and ignore invalid source files.
            unless grunt.file.exists(src)
                grunt.warn 'Source file \'' + src + '\' not found.'

            dest = fileGroup.dest

            # Warn on and ignore invalid compare (dest) files.
            unless grunt.file.exists(dest)
                message = 'Comparison file \'' + dest + '\' not found.'
                if fileGroup.orig.nonull
                    grunt.warn message
                else
                    grunt.log.warn message
                    return # Compare the next file

            fileCount += 1

            origHTML = grunt.file.read src
            compHTML = grunt.file.read dest

            try
                html5compare.compare origHTML, compHTML
                if options.different
                    grunt.warn src + ' is equivalent to ' + dest
            catch e
                unless options.different
                    grunt.warn src + ' is not equivalent to ' + dest + '\n' + e.message

        for fileGroup in @files
            _compareFileGroup fileGroup, options

        # Report number of files compared.
        if fileCount
            grunt.log.ok fileCount + ' pairs of files equivalent.'
        else
            grunt.log.warn fileCount + ' pairs of files compared. Please check your ignored files.'
