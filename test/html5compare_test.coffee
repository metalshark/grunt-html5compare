'use strict'
grunt = require('grunt')
html5compare = require('../tasks/lib/html5compare').init()

#
#    ======== A Handy Little Nodeunit Reference ========
#    https://github.com/caolan/nodeunit
#
#    Test methods:
#        test.expect(numAssertions)
#        test.done()
#    Test assertions:
#        test.ok(value, [message])
#        test.equal(actual, expected, [message])
#        test.notEqual(actual, expected, [message])
#        test.deepEqual(actual, expected, [message])
#        test.notDeepEqual(actual, expected, [message])
#        test.strictEqual(actual, expected, [message])
#        test.notStrictEqual(actual, expected, [message])
#        test.throws(block, [error], [message])
#        test.doesNotThrow(block, [error], [message])
#        test.ifError(value)
#
exports.html5compare =
    setUp: (done) ->
        # setup here if necessary
        done()

    attributeOrdering: (test) ->
        test.expect 1
        test.doesNotThrow(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/attribute-ordering-ordered.html'
                    grunt.file.read 'test/fixtures/attribute-ordering-unordered.html'
                )
            'Equivalent documents with different attribute orders should match.'
        )
        test.done()

    attributesDifferent: (test) ->
        test.expect 1
        test.throws(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/attributes-different-a.html'
                    grunt.file.read 'test/fixtures/attributes-different-b.html'
                )
            'attribute lengths do not match: 2 != 1 in #document->INPUT'
            'Nonequivalent attributes in documents should not match.'
        )
        test.done()

    childDifferent: (test) ->
        test.expect 1
        test.throws(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/child-different-a.html'
                    grunt.file.read 'test/fixtures/child-different-b.html'
                )
            'child lengths do not match: 3 != 1 in #document->HTML->HEAD'
            'Nonequivalent children should not match.'
        )
        test.done()

    childWhitespace: (test) ->
        test.expect 1
        test.doesNotThrow(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/child-whitespace-spaced.html'
                    grunt.file.read 'test/fixtures/child-whitespace-compact.html'
                )
            'Equivalent documents with differences in whitespace should match.'
        )
        test.done()

    contentDifferent: (test) ->
        test.expect 1
        test.throws(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/content-different-a.html'
                    grunt.file.read 'test/fixtures/content-different-b.html'
                )
            'content differs "Foo" != "Bar" in #document->H1->#text'
            'Nonequivalent content should not match.'
        )
        test.done()

    contentSpacing: (test) ->
        test.expect 1
        test.doesNotThrow(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/content-spacing-spaced.html'
                    grunt.file.read 'test/fixtures/content-spacing-compact.html'
                )
            'Equivalent documents with differences in whitespace should match.'
        )
        test.done()

    postText: (test) ->
        test.expect 1
        test.doesNotThrow(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/post-text-spaced.html'
                    grunt.file.read 'test/fixtures/post-text-unspaced.html'
                )
            'Equivalent documents with differences in trailing whitespace should match.'
        )
        test.done()

    preText: (test) ->
        test.expect 1
        test.doesNotThrow(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/pre-text-spaced.html'
                    grunt.file.read 'test/fixtures/pre-text-unspaced.html'
                )
            'Equivalent documents with differences in leading whitespace should match.'
        )
        test.done()

    selfClosing: (test) ->
        test.expect 1
        test.doesNotThrow(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/self-closing-open.html'
                    grunt.file.read 'test/fixtures/self-closing-closed.html'
                )
            'Equivalent documents with differences in tag closing should match.'
        )
        test.done()

    tagCase: (test) ->
        test.expect 1
        test.doesNotThrow(
            ->
                html5compare.compare(
                    grunt.file.read 'test/fixtures/tag-case-lower.html'
                    grunt.file.read 'test/fixtures/tag-case-upper.html'
                )
            'Equivalent documents with differences in tag case should match.'
        )
        test.done()
