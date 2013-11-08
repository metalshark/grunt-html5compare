#
# * grunt-html5compare
# * https://github.com/metalshark/grunt-html5compare
# *
# * Copyright (c) 2013 'Metalshark' Beech Horn
# * Licensed under the LGPL v3 license.
#
'use strict'

module.exports = (grunt) ->

    html5compare = require('./lib/html5compare').init grunt
    path = require('path')

    compareFileGroup = (fileGroup, options) ->
        options = options || {}

        fileGroup.src.forEach (src) ->
            # Warn on and remove invalid source files (if nonull was set).
            unless grunt.file.exists(src)
                grunt.log.warn 'Source file \'' + src + '\' not found.'
                return false

            dest = fileGroup.dest

            # Warn on and remove invalid compare (dest) files (if nonull was set).
            unless grunt.file.exists(dest)
                grunt.log.warn 'Compare file \'' + dest + '\' not found.'
                return false

            if html5compare.compare src, dest, options
                unless options.different
                    grunt.log.ok src + ' is equivalent to ' + dest
                else
                    grunt.log.ok src + ' is not equivalent to ' + dest
                return true
            else
                unless options.different
                    grunt.log.error src + ' is not equivalent to ' + dest
                else
                    grunt.log.error src + ' is equivalent to ' + dest
                return false

    # Please see the grunt documentation for more information regarding task
    # creation: https://github.com/gruntjs/grunt/blob/devel/docs/toc.md
    grunt.registerMultiTask 'html5compare', 'Compares HTML 5 files for equivalence.', ->

        # Merge task-specific and/or target-specific options with these defaults.
        options = @options()
        grunt.verbose.writeflags options, 'Options'

        # Iterate over all specified file groups.
        for fileGroup in @files
            compareFileGroup fileGroup, options
