// Generated by CoffeeScript 1.7.1
'use strict';
var grunt, html5compare;

grunt = require('grunt');

html5compare = require('../tasks/lib/html5compare');

exports.html5compare = {
  setUp: function(done) {
    return done();
  },
  attributeOrdering: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/attribute-ordering-ordered.html'), grunt.file.read('test/fixtures/attribute-ordering-unordered.html'));
    }, 'Equivalent documents with different attribute orders should match.');
    return test.done();
  },
  attributesDifferent: function(test) {
    test.expect(1);
    test.throws(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/attributes-different-a.html'), grunt.file.read('test/fixtures/attributes-different-b.html'));
    }, 'attribute lengths do not match: 2 != 1 in #document->INPUT', 'Nonequivalent attributes in an element should not match.');
    return test.done();
  },
  attributesLengthsDifferent: function(test) {
    test.expect(1);
    test.throws(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/attributes-length-short.html'), grunt.file.read('test/fixtures/attributes-length-long.html'));
    }, 'attribute lengths do not match: (class) != (class, id) in #document->DIV', 'Nonequivalent attribute lengths in elements should not match.');
    return test.done();
  },
  childDifferent: function(test) {
    test.expect(1);
    test.throws(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/child-different-a.html'), grunt.file.read('test/fixtures/child-different-b.html'));
    }, 'child lengths do not match: 3 != 1 in #document->HTML->HEAD', 'Nonequivalent children should not match.');
    return test.done();
  },
  childQuantity: function(test) {
    test.expect(1);
    test.throws(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/child-quantity-2.html'), grunt.file.read('test/fixtures/child-quantity-3.html'));
    }, 'child lengths do not match: (LI, LI) != (LI, LI, LI) in #document->UL', 'Different quantities of children should not match.');
    return test.done();
  },
  childWhitespace: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/child-whitespace-spaced.html'), grunt.file.read('test/fixtures/child-whitespace-compact.html'));
    }, 'Equivalent documents with differences in whitespace should match.');
    return test.done();
  },
  classOrdering: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/class-ordering-ordered.html'), grunt.file.read('test/fixtures/class-ordering-unordered.html'));
    }, 'Equivalent documents with different class orders should match.');
    return test.done();
  },
  classSeparators: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/class-separators-commas.html'), grunt.file.read('test/fixtures/class-separators-spaces.html'));
    }, 'Equivalent documents with different class separators should match.');
    return test.done();
  },
  contentDifferent: function(test) {
    test.expect(1);
    test.throws(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/content-different-a.html'), grunt.file.read('test/fixtures/content-different-b.html'));
    }, 'content differs "Foo" != "Bar" in #document->H1->#text', 'Nonequivalent content should not match.');
    return test.done();
  },
  contentSpacing: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/content-spacing-spaced.html'), grunt.file.read('test/fixtures/content-spacing-compact.html'));
    }, 'Equivalent documents with differences in whitespace should match.');
    return test.done();
  },
  drawTreeView: function(test) {
    var comp, doc, dom, jsdom, node;
    test.expect(1);
    jsdom = require('jsdom').jsdom;
    doc = grunt.file.read('test/fixtures/treeview.html');
    dom = jsdom(doc);
    node = dom.getElementsByTagName('a')[0];
    comp = html5compare.drawTreeView(dom, node);
    test.equal('#document\n-DIV#\n--\n--P#lead.great\n---Hello World\n--\n--STRONG#.heavy\n---its a strong\n--\n--A#\n', comp, 'Treeviews should be created consistently.');
    return test.done();
  },
  noClass: function(test) {
    test.expect(1);
    test.throws(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/no-class-with.html'), grunt.file.read('test/fixtures/no-class-without.html'));
    }, 'attribute values do not match: "foo" != "" in #document->HR.class', 'Equivalent documents with differences in trailing whitespace should match.');
    return test.done();
  },
  postText: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/post-text-spaced.html'), grunt.file.read('test/fixtures/post-text-compact.html'));
    }, 'Equivalent documents with differences in trailing whitespace should match.');
    return test.done();
  },
  preText: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/pre-text-spaced.html'), grunt.file.read('test/fixtures/pre-text-compact.html'));
    }, 'Equivalent documents with differences in leading whitespace should match.');
    return test.done();
  },
  selfClosing: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/self-closing-open.html'), grunt.file.read('test/fixtures/self-closing-closed.html'));
    }, 'Equivalent documents with differences in tag closing should match.');
    return test.done();
  },
  siblingWhitespace: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/sibling-whitespace-spaced.html'), grunt.file.read('test/fixtures/sibling-whitespace-compact.html'));
    }, 'Equivalent documents with differences in whitespace between siblings should match.');
    return test.done();
  },
  tagCase: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/tag-case-lower.html'), grunt.file.read('test/fixtures/tag-case-upper.html'));
    }, 'Equivalent documents with differences in tag case should match.');
    return test.done();
  },
  textDifferent: function(test) {
    test.expect(1);
    test.throws(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/text-different-a.html'), grunt.file.read('test/fixtures/text-different-b.html'));
    }, 'content differs "Foo Bar" != "Bar Foo" in #document->P->#text', 'Text elements with different contents should not match.');
    return test.done();
  },
  textWhitespace: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/text-whitespace-spaced.html'), grunt.file.read('test/fixtures/text-whitespace-compact.html'));
    }, 'Equivalent documents with differences in text whitespace should match.');
    return test.done();
  },
  voidAttributes: function(test) {
    test.expect(1);
    test.doesNotThrow(function() {
      return html5compare.compare(grunt.file.read('test/fixtures/void-attributes-explicit.html'), grunt.file.read('test/fixtures/void-attributes-implicit.html'));
    }, 'Void attributes should match whether explicit or implicit.');
    return test.done();
  }
};

//# sourceMappingURL=html5compare_test.map
