grunt-html5compare
==================

Compares HTML 5 files for equivalence.

Windows users
-------------

This package relies on [jsdom](https://github.com/tmpvar/jsdom), which itself
relies on [contextify](https://github.com/brianmcd/contextify) that then relies
on [node-gyp](https://github.com/TooTallNate/node-gyp).

node-gyp is a build tool and that mean Windows needs a build environment.
Thankfully there is a guide
[a guide](https://github.com/TooTallNate/node-gyp#installation)
which should make life easier.
