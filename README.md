[![Build Status](https://travis-ci.org/metalshark/grunt-html5compare.png)](https://travis-ci.org/metalshark/grunt-html5compare)
[![Dependency Status](https://david-dm.org/metalshark/grunt-html5compare.png)](https://david-dm.org/metalshark/grunt-html5compare)
[![DevDependency Status](https://david-dm.org/metalshark/grunt-html5compare/dev-status.png)](https://david-dm.org/metalshark/grunt-html5compare#info=devDependencies)

grunt-html5compare
==================

> Compares HTML 5 files for equivalence.

Introduction
------------

Ever needed to compare two HTML 5 files to make sure they match for unittests,
then realised that using simple diffs meant that attribute ordering and
whitespace caused problems? Well grunt-html5compare is the tool for the job!

Please have a look at the
[actual comparison](https://github.com/metalshark/grunt-html5compare/blob/master/tasks/lib/html5compare.litcoffee)
itself for details and feel free to
[raise an issue](https://github.com/metalshark/grunt-html5compare/issues/new)
if there is anything missing.

Windows users
-------------

This package relies on [jsdom](https://github.com/tmpvar/jsdom), which itself
relies on [contextify](https://github.com/brianmcd/contextify) that then relies
on [node-gyp](https://github.com/TooTallNate/node-gyp).

node-gyp is a build tool and that mean Windows needs a build environment.
Thankfully there is
[a guide](https://github.com/TooTallNate/node-gyp#installation) which should
make life easier.

Getting Started
---------------
This plugin requires Grunt `~0.4.5`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out
the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains
how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as
install and use Grunt plugins. Once you're familiar with that process, you may
install this plugin with this command:

```shell
npm install grunt-html5compare --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with
this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-html5compare');
```

*This plugin was designed to work with Grunt 0.4.x.


html5compare task
-----------------
_Run this task with the `grunt html5compare` command._

Task targets, files and options may be specified according to the grunt
[Configuring tasks](http://gruntjs.com/configuring-tasks) guide.

Please be aware the the destination file(s) will be compared to the source
file(s). If you can suggest a better syntax, then please raise an issue with a
proposal.

### Options

#### different
Type: `Boolean`
Default: false

Only pass if the files are different.

Usage Examples
-----------------

```js
html5compare: {

    // Normal comparison of HTML files
    singleTask: {
      files: [
        {
          'comparison.html': 'original.html' // compare the two files
        }
      ]
    },

    // Reverse the logic so it only passes if files are different
    singleTaskDifferent: {
      options: {
        different: true // passes if they do not match
      },
      files: [
        {
          'comparison.html': 'original.html'
        }
      ]
    },

    // Expanded syntax
    singleTaskDifferent: {
        files: [
            expand: true,
            cwd: 'tests',
            src: 'originals/**/*.html'
            dest: 'comparisons',
            ext: '.html'
        ]
    }
  }
```
