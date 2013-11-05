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

        # Configuration to be run (and then tested).
        html5compare:
            defaultOptions:
                options: {}
                files:
                    '<%= app.temp %>/default_options': [
                        '<%= app.test %>/fixtures/testing'
                        '<%= app.test %>/fixtures/123'
                    ]

            customOptions:
                options:
                    separator: ': '
                    punctuation: ' !!!'

                files:
                    '<%= app.temp %>/custom_options': [
                        '<%= app.test %>/fixtures/testing'
                        '<%= app.test %>/fixtures/123'
                    ]

        # grunt-contrib-jshint: https://github.com/gruntjs/grunt-contrib-jshint
        # Validate files with JSHint.
        jshint:
            all: [
                '<%= app.temp %>/Gruntfile.js'
                '<%= app.temp %>/tasks/**/*.js'
                '<%= nodeunit.tests %>'
            ]
            options:
                jshintrc: '.jshintrc'

        # Unit tests.
        nodeunit:
            tests: [
                '<%= app.temp %>/test/**/*_test.js'
            ]

    # Actually load this plugin's task(s).
    grunt.loadTasks 'tasks'

    # Whenever the 'test' task is run, first clean the temp dir, then run this
    # plugin's task(s), then test the result.
    grunt.registerTask 'test', [
        'clean'
        'coffee'
        'html5compare'
        'nodeunit'
    ]

    # By default, lint and run all tests.
    grunt.registerTask 'default', [
        'coffee'
        'jshint'
        'test'
    ]