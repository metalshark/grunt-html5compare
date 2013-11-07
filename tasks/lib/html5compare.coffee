#
# * grunt-html5compare
# * https://github.com/metalshark/grunt-html5compare
# *
# * Copyright (c) 2013 'Metalshark' Beech Horn
# * Licensed under the LGPL v3 license.
#
'use strict'
exports.init = (grunt) ->

    jsdom = require('jsdom').jsdom

    compareElements = (orig, comp, options) ->
        options = options || {}

        unless orig.nodeName == comp.nodeName
            return false

        if orig.attributes
            if orig.attributes.length != comp.attributes.length
                return false

            failed = false
            for attr in orig.attributes
                if attr.value != comp.getAttribute(attr.name)
                    failed = true
            if failed
                return false

        if orig.hasChildNodes
            if orig.childNodes.length != comp.childNodes.length
                return false

            for origChildNode, index in orig.childNodes
                if not compareElements origChildNode, comp.childNodes[index]
                    return false

        return true

    exports.compare = (orig, comp, options) ->
        options = options || {}

        origHTML = grunt.file.read(orig)
        compHTML = grunt.file.read(comp)

        origDOM = jsdom(origHTML)
        compDOM = jsdom(compHTML)

        result = compareElements(origDOM, compDOM, options)

        if options.different
            return not result

        return result

    return exports
