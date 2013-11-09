#
# * grunt-html5compare
# * https://github.com/metalshark/grunt-html5compare
# *
# * Copyright (c) 2013 'Metalshark' Beech Horn
# * Licensed under the LGPL v3 license.
#
'use strict'
exports.init = () ->

    jsdom = require('jsdom').jsdom

    trim_whitespace = (dom) ->
        if dom.innerHTML
            dom.innerHTML = dom.innerHTML.replace /^[\n\r\s\t]+|[\n\r\s\t]+$/gm, ''

        if dom.hasChildNodes()
            firstChild = dom.firstChild
            if firstChild.nodeName == '#text'
                if firstChild.textContent.match /^[\n\r\s\t]+$/gm
                    dom.removeChild firstChild

        if dom.hasChildNodes()
            lastChild = dom.lastChild
            if lastChild.nodeName == '#text'
                if lastChild.textContent.match /^[\n\r\s\t]+$/gm
                    dom.removeChild lastChild

        if dom.hasChildNodes()
            for childNode in dom.childNodes
                trim_whitespace childNode

    exports.compare = (orig, comp) ->
        origDOM = jsdom orig
        compDOM = jsdom comp

        trim_whitespace origDOM
        trim_whitespace compDOM

        compareElements origDOM, compDOM

    compareElements = (orig, comp, nodePath) ->
        nodePath = nodePath || []

        nodePath = [].concat(nodePath)
        nodePath.push orig.nodeName

        unless orig.nodeName == comp.nodeName
            throw new Error('nodeNames do not match: ' + orig.nodeName +
                            ' != ' + comp.nodeName +
                            ' in ' + nodePath.join('->'))

        if orig.attributes
            if orig.attributes.length != comp.attributes.length
                throw new Error('attribute lengths do not match: ' +
                                orig.attributes.length + ' != ' +
                                comp.attributes.length + ' in ' +
                                nodePath.join('->'))

            for attr in orig.attributes
                if attr.value != comp.getAttribute(attr.name)
                    throw new Error('attribute values do not match: "' +
                                    attr.value + '" != "' +
                                    comp.getAttribute(attr.name) + '" in ' +
                                    nodePath.join('->') + '.' + attr.name)

        if orig.hasChildNodes()
            if orig.childNodes.length != comp.childNodes.length
                throw new Error('child lengths do not match: ' +
                                orig.childNodes.length + ' != ' +
                                comp.childNodes.length + ' in ' +
                                nodePath.join('->'))

            for origChildNode, index in orig.childNodes
                compareElements origChildNode, comp.childNodes[index], nodePath

        # Test child nodes before textContent as the error output is better
        if orig.nodeName == '#text'
            origText = orig.textContent.replace /^[\n\r\s\t]+|[\n\r\s\t]+$/gm, ''
            compText = comp.textContent.replace /^[\n\r\s\t]+|[\n\r\s\t]+$/gm, ''
            if origText != compText
                throw new Error('content differs "' + origText +
                                '" != "' + compText +
                                '" in ' + nodePath.join('->'))

    return exports
