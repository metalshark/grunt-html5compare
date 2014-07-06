grunt-html5compare
==================

https://github.com/metalshark/grunt-html5compare

Copyright (c) 2014 'Metalshark' Beech Horn
Licensed under the LGPL v3 license.

Strict helps to trap more potential bugs.

    'use strict'

Using [jsdom](https://github.com/tmpvar/jsdom) to interpret HTML and produce
objects for easy comparison, in particular the
[jsdom.jsdom method](https://github.com/tmpvar/jsdom#for-the-hardcore).

    jsdom = require('jsdom').jsdom

Comparing HTML Documents
------------------------

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

Trimming Whitespace
-------------------

Remove any whitespace padding, including independent #text nodes only containing
whitespace. If there are any problems with files needing whitespace for
comparison then please
[raise an issue](https://github.com/metalshark/grunt-html5compare/issues/new).

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

`trim_text_whitespace` is used for comparing text content without having to
worry about whitespace differences. First all whitespace is converted into a
space character, then repeating whitespace sequences are converted to a singular
space character, before finally removing all leading and trailing spaces.

    trim_text_whitespace = (text) ->
        text = text.replace /[\n\r\s\t]/gm, ' '
        text = text.replace /[\s][\s]+/g, ' '
        text = text.replace /^[\s]+|[\s]+$/g, ''
        return text

Comparing DOMs
--------------

Designed to be run recursively on child elements, this is where we compare the
two DOMs.

The `nodePath` variable is an array of element names used for error messages.
By cloning (`[].concat`) the array of names is trimmed to a linear path through
the DOM. Without cloning you will end up with a zig zag pattern, as it will
record *every* element it is called on in the DOM.

**TODO**: Display a tree view of DOM elements compared so far. It should also
highlight the element which failed comparison.

    compareElements = (orig, comp, nodePath) ->
        nodePath = nodePath || []

        nodePath = [].concat(nodePath)
        nodePath.push orig.nodeName

First we check that the element names (`HTML`, `HEAD`, 'STRONG', etc) are the
same.
[jsdom](https://github.com/tmpvar/jsdom) makes every element's name upper case,
except those which are # prefixed (e.g. #document, #text, etc) which are made
lower case. This means we can compare `nodeName` without worrying about case.

        unless orig.nodeName == comp.nodeName
            throw new Error('nodeNames do not match: ' + orig.nodeName +
                            ' != ' + comp.nodeName +
                            ' in ' + nodePath.join('->'))

Comparing Attributes
--------------------

Comparing attributes using a simple test for lengths before comparing values.
The attribute names are collected and then shown in the error message.

        if orig.attributes
            if orig.attributes.length != comp.attributes.length
                origAttrNames = []
                compAttrNames = []
                for attr in orig.attributes
                    origAttrNames.push(attr.name)
                for attr in comp.attributes
                    compAttrNames.push(attr.name)
                throw new Error('attribute lengths do not match: ' +
                                '(' + origAttrNames.join(', ') + ')' + ' != ' +
                                '(' + compAttrNames.join(', ') + ')' + ' in ' +
                                nodePath.join('->'))

`attr` is the original element's attribute, whilst `compValue` holds the
comparison element's attribute value, determined by the original element's
attribute name.

We use a variable to hold the comparison value (`compValue`) and `attr` is the
original file's attribute.

When the attribute value is the same as the name e.g. checked=checked then
we set the value to an empty string, which is the alternative syntax. This way
we can continue using the same comparison below without having to treat a list
of names/values as *special cases*. If you find a special case then please
[raise an issue](https://github.com/metalshark/grunt-html5compare/issues/new).

            for attr in orig.attributes
                compValue = comp.getAttribute(attr.name)

                if attr.name == attr.value
                    attr.value = ''

                if attr.name == compValue
                    compValue = ''

Handling the Class Attribute
----------------------------

The class attribute can be separated a by comma or space, so it may be a
different value in the two files we are comparing even though they mean the
same thing. By splitting on either character, sorting alphabetically and joining
again it should make both class values the same so we can compare them.

**TODO:** See if there is a way to use
[sets](http://docs.python.org/2/library/sets.html)
in JavaScript instead.

                if attr.name == 'class'
                    attr.value = attr.value.split(/[\s,]+/).sort().join(' ')
                    if compValue
                        compValue = compValue.split(/[\s,]+/).sort().join(' ')
                    else
                        compValue = []

There may be additional cases where this simple comparison of attribute values
is undesirable (such as for class above), if you find anything please
[raise an issue](https://github.com/metalshark/grunt-html5compare/issues/new).

                if attr.value != compValue
                    throw new Error('attribute values do not match: "' +
                                    attr.value + '" != "' +
                                    compValue + '" in ' +
                                    nodePath.join('->') + '.' + attr.name)


Comparing Children
------------------

Comparing how many child nodes each element has using a simple test for lengths
matching first.

        if orig.hasChildNodes()
            unless orig.childNodes.length == comp.childNodes.length

If the number of child nodes does not match then list the element names of each
child node to help spot the difference. As this will be a nodeList we cannot
simply use a map statement.

                origChildren = []
                compChildren = []
                for node in orig.childNodes
                    origChildren.push node.nodeName
                for node in comp.childNodes
                    compChildren.push node.nodeName

                throw new Error('child lengths do not match: (' +
                                origChildren.join(', ') + ') != (' +
                                compChildren.join(', ') + ') in ' +
                                nodePath.join('->'))

Recursively Compare Children
----------------------------

Here is where we recursively call `compareElements` (this function) on child
nodes. As the comparison utility raises/throws exceptions rather than returning
true or false, we can ignore the return value.

            for origChildNode, index in orig.childNodes
                compareElements origChildNode, comp.childNodes[index], nodePath

Comparing Text
--------------

Finally we compare any text differences. This test comes after the child tests
as the output is more specific from a child with differing text than a parent.
We could just add an `if` statement to this to check that it is a leaf node (an
element without children) however that will likely need more clauses added to it
as exceptions are found.
First all whitespace is converted into a space character, then repeating
whitespace sequences are converted to a singular space character, before finally
removing all leading and trailing spaces.

        if orig.nodeName == '#text'
            origText = trim_text_whitespace orig.textContent
            compText = trim_text_whitespace comp.textContent

            if origText != compText
                throw new Error('content differs "' + origText +
                                '" != "' + compText +
                                '" in ' + nodePath.join('->'))
