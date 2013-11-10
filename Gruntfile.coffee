###
grunt-html5compare
https://github.com/metalshark/grunt-html5compare

Copyright (c) 2013 'Metalshark' Beech Horn
Licensed under the LGPL v3 license.
###
'use strict'
module.exports = (grunt) ->

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
            # Before generating any new files, remove any previously-created files.
            tests: [
                '<%= app.temp %>'
            ]

        # grunt-contrib-coffee: https://github.com/gruntjs/grunt-contrib-coffee
        # Compile CoffeeScript files to JavaScript.
        coffee:
            gruntfile:
                files: [
                    '<%= app.temp %>/Gruntfile.js': 'Gruntfile.coffee'
                ]

            tasks:
                files: [
                    expand: true
                    cwd: '<%= app.tasks %>'
                    src: '**/*.coffee'
                    dest: '<%= app.temp %>/tasks'
                    ext: '.js'
                ]

            test:
                files: [
                    expand: true
                    cwd: '<%= app.test %>'
                    src: '**/*.coffee'
                    dest: '<%= app.temp %>/test'
                    ext: '.js'
                ]

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
                    '<%= app.test %>/fixtures/attribute-ordering-unordered.html':
                        '<%= app.test %>/fixtures/attribute-ordering-ordered.html'

                    '<%= app.test %>/fixtures/child-whitespace-spaced.html':
                        '<%= app.test %>/fixtures/child-whitespace-compact.html'

                    '<%= app.test %>/fixtures/class-ordering-unordered.html':
                        '<%= app.test %>/fixtures/class-ordering-ordered.html'

                    '<%= app.test %>/fixtures/class-separators-spaces.html':
                        '<%= app.test %>/fixtures/class-separators-commas.html'

                    '<%= app.test %>/fixtures/content-spacing-spaced.html':
                        '<%= app.test %>/fixtures/content-spacing-compact.html'

                    '<%= app.test %>/fixtures/post-text-spaced.html':
                        '<%= app.test %>/fixtures/post-text-compact.html'

                    '<%= app.test %>/fixtures/pre-text-spaced.html':
                        '<%= app.test %>/fixtures/pre-text-compact.html'

                    '<%= app.test %>/fixtures/self-closing-closed.html':
                        '<%= app.test %>/fixtures/self-closing-open.html'

                    '<%= app.test %>/fixtures/tag-case-upper.html':
                        '<%= app.test %>/fixtures/tag-case-lower.html'

                    '<%= app.test %>/fixtures/void-attributes-explicit.html':
                        '<%= app.test %>/fixtures/void-attributes-implicit.html'
                ]

            singleTaskDifferent:
                options:
                    different: true
                files: [
                    '<%= app.test %>/fixtures/attributes-different-a.html':
                        '<%= app.test %>/fixtures/attributes-different-b.html'

                    '<%= app.test %>/fixtures/child-different-a.html':
                        '<%= app.test %>/fixtures/child-different-b.html'

                    '<%= app.test %>/fixtures/no-class-without.html':
                        '<%= app.test %>/fixtures/no-class-with.html'

                    '<%= app.test %>/fixtures/content-different-a.html':
                        '<%= app.test %>/fixtures/content-different-b.html'
                ]

            multiTask:
                files: [
                    expand: true
                    cwd: '<%= app.test %>'
                    src: 'fixtures/**/*.html'
                    dest: '<%= app.test %>'
                    ext: '.html'
                ]

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
