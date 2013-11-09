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

        whitespaceChildren = []
        if dom.hasChildNodes()
            for childNode in dom.childNodes
                if childNode.nodeName == '#text'
                    if childNode.textContent.match /^[\n\r\s\t]+$/gm
                        whitespaceChildren.push childNode

        for childNode in whitespaceChildren
            dom.removeChild childNode

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
                compValue = comp.getAttribute(attr.name)

                if attr.name == attr.value
                    attr.value = ''

                if attr.name == compValue
                    compValue = ''

                if attr.value != compValue
                    throw new Error('attribute values do not match: "' +
                                    attr.value + '" != "' +
                                    compValue + '" in ' +
                                    nodePath.join('->') + '.' + attr.name)

        if orig.hasChildNodes()
            if orig.childNodes.length != comp.childNodes.length
                origChildren = []
                for origChildNode in orig.childNodes
                    origChildren.push origChildNode.nodeName
                compChildren = []
                for compChildNode in comp.childNodes
                    compChildren.push compChildNode.nodeName

                throw new Error('child lengths do not match: (' +
                                origChildren.join(', ') + ') != (' +
                                compChildren.join(', ') + ') in ' +
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
