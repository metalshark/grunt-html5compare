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
        fileCount = 0

        _compareFileGroup = (fileGroup, options) ->
            for src in fileGroup.src
                _compareSrc src, fileGroup, options

        _compareSrc = (src, fileGroup, options) ->
            # Warn on and remove invalid source files (if nonull was set).
            unless grunt.file.exists(src)
                grunt.warn 'Source file \'' + src + '\' not found.'
                return false

            dest = fileGroup.dest

            # Warn on and remove invalid compare (dest) files (if nonull was set).
            unless grunt.file.exists(dest)
                grunt.warn 'Compare file \'' + dest + '\' not found.'
                return false

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
        grunt.log.ok fileCount + ' pairs of files equivalent.'
