#
# * grunt-html5compare
# * https://github.com/metalshark/grunt-html5compare
# *
# * Copyright (c) 2013 'Metalshark' Beech Horn
# * Licensed under the LGPL v3 license.
#
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

        # Configuration to be run (and then tested).
        #html5compare:

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
        #'html5compare'
        'nodeunit'
    ]

    # By default, lint and run all tests.
    grunt.registerTask 'default', [
        'coffeelint'
        'coffee'
        'jshint'
        'test'
    ]
