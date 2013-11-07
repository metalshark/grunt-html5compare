'use strict'
grunt = require('grunt')
html5compare = require('../tasks/lib/html5compare').init(grunt)

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
        test.ok(
            html5compare.compare(
                'test/fixtures/attribute-ordering-ordered.html'
                'test/fixtures/attribute-ordering-unordered.html'
            )
            'Equivalent documents with different attribute orders should match.'
        )
        test.done()

    attributesDifferent: (test) ->
        test.expect 1
        test.equal(
            html5compare.compare(
                'test/fixtures/attributes-different-a.html'
                'test/fixtures/attributes-different-b.html'
            )
            false
            'Nonequivalent attributes in documents should not match.'
        )
        test.done()

    attributesDifferentPasses: (test) ->
        test.expect 1
        test.ok(
            html5compare.compare(
                'test/fixtures/attributes-different-a.html'
                'test/fixtures/attributes-different-b.html',
                { different: true }
            )
            'Nonequivalent attributes in documents should match with different specified.'
        )
        test.done()

    childDifferent: (test) ->
        test.expect 1
        test.equal(
            html5compare.compare(
                'test/fixtures/child-different-a.html'
                'test/fixtures/child-different-b.html'
            )
            false
            'Nonequivalent children should not match.'
        )
        test.done()

    childDifferentPasses: (test) ->
        test.expect 1
        test.ok(
            html5compare.compare(
                'test/fixtures/child-different-a.html'
                'test/fixtures/child-different-b.html',
                { different: true }
            )
            'Nonequivalent children should match with different specified.'
        )
        test.done()

    contentDifferent: (test) ->
        test.expect 1
        test.equal(
            html5compare.compare(
                'test/fixtures/content-different-a.html'
                'test/fixtures/content-different-b.html'
            )
            false
            'Nonequivalent content should not match.'
        )
        test.done()

    contentDifferentPasses: (test) ->
        test.expect 1
        test.ok(
            html5compare.compare(
                'test/fixtures/content-different-a.html'
                'test/fixtures/content-different-b.html',
                { different: true }
            )
            'Nonequivalent content should match with different specified.'
        )
        test.done()

    contentSpacing: (test) ->
        test.expect 1
        test.ok(
            html5compare.compare(
                'test/fixtures/content-spacing-spaced.html'
                'test/fixtures/content-spacing-compact.html'
            )
            'Equivalent documents with differences in whitespace should match.'
        )
        test.done()

    selfClosing: (test) ->
        test.expect 1
        test.ok(
            html5compare.compare(
                'test/fixtures/self-closing-open.html'
                'test/fixtures/self-closing-closed.html'
            )
            'Equivalent documents with differences in tag closing should match.'
        )
        test.done()

    tagCase: (test) ->
        test.expect 1
        test.ok(
            html5compare.compare(
                'test/fixtures/tag-case-lower.html'
                'test/fixtures/tag-case-upper.html'
            )
            'Equivalent documents with differences in tag case should match.'
        )
        test.done()
