###
grunt-html5compare
https://github.com/metalshark/grunt-html5compare

Copyright (c) 2014 'Metalshark' Beech Horn
Licensed under the LGPL v3 license.
###
'use strict'
module.exports = (grunt) ->

    # show elapsed time at the end
    require('time-grunt') grunt

    # load all grunt tasks
    require('load-grunt-tasks') grunt

    # Project configuration.
    grunt.initConfig

        app:
            tasks: 'tasks'
            temp: '.tmp'
            test: 'test'

        # grunt-contrib-clean: https://github.com/gruntjs/grunt-contrib-clean
        # Clear files and folders.
        clean:
            temp:
                dot: true
                src: '<%= app.temp %>'

        # grunt-contrib-coffee: https://github.com/gruntjs/grunt-contrib-coffee
        # Compile CoffeeScript files to JavaScript.
        coffee:
            gruntfile:
                src: 'Gruntfile.coffee'
                dest: '<%= app.temp %>/Gruntfile.js'

            tasks:
                expand: true
                cwd: '<%= app.tasks %>'
                src: '**/*.coffee'
                dest: '<%= app.temp %>/tasks'
                ext: '.js'

            test:
                expand: true
                cwd: '<%= app.test %>'
                src: '**/*.coffee'
                dest: '<%= app.temp %>/test'
                ext: '.js'

        # grunt-coffeelint: https://github.com/vojtajina/grunt-coffeelint
        # Lint your CoffeeScript using grunt.js and coffeelint.
        coffeelint:
            options:
                indentation:
                    value: 4
                max_line_length:
                    value: 120
            all: [
                'Gruntfile.coffee'
                '<%= app.tasks %>/**/*.coffee'
                '<%= app.test %>/**/*.coffee'
            ]

        # Configuration to be run for testing.
        html5compare:
            singleTask:
                files: [
                    nonull: true
                    src: '<%= app.test %>/fixtures/attribute-ordering-unordered.html'
                    dest:'<%= app.test %>/fixtures/attribute-ordering-ordered.html'
                ,
                    nonull: true
                    src:' <%= app.test %>/fixtures/child-whitespace-spaced.html'
                    dest: '<%= app.test %>/fixtures/child-whitespace-compact.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/class-ordering-unordered.html'
                    dest: '<%= app.test %>/fixtures/class-ordering-ordered.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/class-separators-spaces.html'
                    dest: '<%= app.test %>/fixtures/class-separators-commas.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/content-spacing-spaced.html'
                    dest: '<%= app.test %>/fixtures/content-spacing-compact.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/post-text-spaced.html'
                    dest: '<%= app.test %>/fixtures/post-text-compact.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/pre-text-spaced.html'
                    dest: '<%= app.test %>/fixtures/pre-text-compact.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/self-closing-closed.html'
                    dest: '<%= app.test %>/fixtures/self-closing-open.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/tag-case-upper.html'
                    dest: '<%= app.test %>/fixtures/tag-case-lower.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/text-whitespace-spaced.html'
                    dest: '<%= app.test %>/fixtures/text-whitespace-compact.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/void-attributes-explicit.html'
                    dest: '<%= app.test %>/fixtures/void-attributes-implicit.html'
                ]

            singleTaskDifferent:
                options:
                    different: true
                files: [
                    nonull: true
                    src: '<%= app.test %>/fixtures/attributes-different-a.html'
                    dest: '<%= app.test %>/fixtures/attributes-different-b.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/attributes-length-short.html'
                    dest:'<%= app.test %>/fixtures/attributes-length-long.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/child-different-a.html'
                    dest: '<%= app.test %>/fixtures/child-different-b.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/child-quantity-2.html'
                    dest: '<%= app.test %>/fixtures/child-quantity-3.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/content-different-a.html'
                    dest: '<%= app.test %>/fixtures/content-different-b.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/no-class-without.html'
                    dest: '<%= app.test %>/fixtures/no-class-with.html'
                ,
                    nonull: true
                    src: '<%= app.test %>/fixtures/text-different-a.html'
                    dest: '<%= app.test %>/fixtures/text-different-b.html'
                ]

            multiTask:
                expand: true
                cwd: '<%= app.test %>'
                src: 'fixtures/**/*.html'
                dest: '<%= app.test %>'
                ext: '.html'

            invalidSrc:
                src: 'no-such-file.html'
                dest: '<%= app.test %>/fixtures/attributes-different-a.html'

            invalidDest:
                src: '<%= app.test %>/fixtures/attributes-different-a.html'
                dest: 'no-such-file.html'

        # grunt-contrib-jshint: https://github.com/gruntjs/grunt-contrib-jshint
        # Validate files with JSHint.
        jshint:
            all: [
                '<%= app.temp %>/Gruntfile.js'
                '<%= app.temp %>/tasks/**/*.js'
                '<%= app.temp %>/test/**/*.js'
            ]
            options:
                jshintrc: '.jshintrc'

        # Unit tests.
        nodeunit:
            tests: [
                '<%= app.test %>/**/*_test.coffee'
            ]

    # Actually load this plugin's task(s).
    grunt.loadTasks 'tasks'

    # Whenever the 'test' task is run, first clean the temp dir, then run this
    # plugin's task(s), then test the result.
    grunt.registerTask 'test', [
        'clean'
        'html5compare'
        'nodeunit'
    ]

    # By default, lint and run all tests.
    grunt.registerTask 'default', [
        'coffeelint'
        'coffee'
        'jshint'
        'test'
    ]
