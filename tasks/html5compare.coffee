#
# * grunt-html5compare
# * https://github.com/metalshark/grunt-html5compare
# *
# * Copyright (c) 2013 'Metalshark' Beech Horn
# * Licensed under the LGPL v3 license.
#
'use strict'
module.exports = (grunt) ->

    # Please see the grunt documentation for more information regarding task
    # creation: https://github.com/gruntjs/grunt/blob/devel/docs/toc.md
    grunt.registerMultiTask 'html5compare', 'Compares HTML 5 files for equivalence.', ->

        # Merge task-specific and/or target-specific options with these defaults.
        options = @options(
            punctuation: '.'
            separator: ', '
        )

        # Iterate over all specified file groups.
        @files.forEach (fileObj) ->

            # The source files to be concatenated. The 'nonull' option is used
            # to retain invalid files/patterns so they can be warned about.
            files = grunt.file.expand(
                nonull: true
            , fileObj.src)

            # Concat specified files.

            # Warn if a source file/pattern was invalid.

            # Read file source.
            src = files.map((filepath) ->
                unless grunt.file.exists(filepath)
                    grunt.log.error 'Source file \'' + filepath + '\' not found.'
                    return ''
                grunt.file.read filepath
            ).join(options.separator)

            # Handle options.
            src += options.punctuation

            # Write the destination file.
            grunt.file.write fileObj.dest, src

            # Print a success message.
            grunt.log.writeln 'File \'' + fileObj.dest + '\' created.'

