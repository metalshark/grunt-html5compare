grunt-html5compare
==================

https://github.com/metalshark/grunt-html5compare

Copyright (c) 2013 'Metalshark' Beech Horn
Licensed under the LGPL v3 license.

Strict helps to trap more potential bugs.

    'use strict'

Using [jsdom](https://github.com/tmpvar/jsdom) to interpret HTML and produce
objects for easy comparison.

    jsdom = require('jsdom').jsdom

We expose just the compare function when this library is required. By only
accepting the HTML contents as a string, any file reading or network I/O is
handled outside of the comparison library.

The DOMs are created using [jsdom](https://github.com/tmpvar/jsdom) and then
trimmed for whitespace. Finally the top most dom element `#document` from both
files is sent to `compareElements` which recursively calls itself on
child elements.

    exports.compare = (orig, comp) ->
        origDOM = jsdom orig
        compDOM = jsdom comp

        trim_whitespace origDOM
        trim_whitespace compDOM

        compareElements origDOM, compDOM

Remove any whitespace padding, including independent #text nodes only containing
whitespace. If there are any problems with files needing whitespace for
comparison then either an option can be added or we can refine this function.

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

Designed to be run recursively on child elements, this is where we compare the
two DOMs.

The `nodePath` variable is so that the path of nodes navigated to so far can be
shown in error messages to make it easier for developers to spot the difference.
Ultimately there should really be a tree view of DOM elements with colour
syntaxing.

    compareElements = (orig, comp, nodePath) ->
        nodePath = nodePath || []

        nodePath = [].concat(nodePath)
        nodePath.push orig.nodeName

First we check that the node names (`HTML`, `HEAD`, etc) match.
[jsdom](https://github.com/tmpvar/jsdom) makes every element's name upper case
except those which are # prefixed (#document, #text, etc), which it makes lower
case. This means we can compare `nodeName` without worrying about case.

        unless orig.nodeName == comp.nodeName
            throw new Error('nodeNames do not match: ' + orig.nodeName +
                            ' != ' + comp.nodeName +
                            ' in ' + nodePath.join('->'))

Comparing attributes using a simple test for lengths matching first, then
setting a default of an empty string `""` so that other comparisons are simpler.

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

The class attribute can be separated by comma or space. By splitting on either,
sorting alphabetically and joining again it is possible to compare simply.

                if attr.name == 'class'
                    attr.value = attr.value.split(/[\s,]+/).sort().join(' ')
                    if compValue
                        compValue = compValue.split(/[\s,]+/).sort().join(' ')
                    else
                        compValue = []

There may be additional cases where this simple comparison of attribute values
is undesirable (such as for class above), however they are yet to present
themselves.

                if attr.value != compValue
                    throw new Error('attribute values do not match: "' +
                                    attr.value + '" != "' +
                                    compValue + '" in ' +
                                    nodePath.join('->') + '.' + attr.name)

Comparing how many child nodes each element has.

        if orig.hasChildNodes()
            if orig.childNodes.length != comp.childNodes.length

If the number of child nodes do not match then list the element names of each
child node to help spot the difference.

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

Finally we compare any text differences. This test comes after the child tests
as the output is more specific from a child with differing text than the parent.
We could just add an if statement to this to check that it is a leaf node (an
element without children) however that will likely need more clauses added to it
as exceptions are found.

        if orig.nodeName == '#text'
            origText = orig.textContent.replace /^[\n\r\s\t]+|[\n\r\s\t]+$/gm, ''
            compText = comp.textContent.replace /^[\n\r\s\t]+|[\n\r\s\t]+$/gm, ''
            if origText != compText
                throw new Error('content differs "' + origText +
                                '" != "' + compText +
                                '" in ' + nodePath.join('->'))
