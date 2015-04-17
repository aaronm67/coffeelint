###

The MIT License (MIT)

Copyright (c) 2013 Pawel Maciejewski

Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

###
path = require 'path'
vows = require 'vows'
assert = require 'assert'
fs = require 'fs'
coffeelint = require path.join('..', 'lib', 'coffeelint')
_ = require 'lodash'

config = {

}

getErrors = (source) ->
    errors = coffeelint.lint(source, config)
    _.filter(errors, (error) -> error.name == 'variable_scope')

getFixtureSource = (fixture) ->
    return fs.readFileSync(
        "#{__dirname}/fixtures/variable-scope/#{fixture}.coffee"
    ).toString()

vows.describe('test_variable_scope').addBatch({
    'Basic Example':
        topic: () ->
            return getFixtureSource('basic')

        'There are three errors': (source) ->
            errors = getErrors(source)
            assert.equal errors.length, 3

        'First error is between first and fifth line': (source) ->
            errors = getErrors(source)
            assert.equal errors[0].lineNumber, 1
            assert.equal errors[0].lineNumberEnd, 5

        'Second error is between second and eleventh line': (source) ->
            errors = getErrors(source)
            assert.equal errors[1].lineNumber, 2
            assert.equal errors[1].lineNumberEnd, 11

        'First error is on variable"a"': (source) ->
            errors = getErrors(source)
            assert.equal errors[0].context, 'a'

    'Object literal':
        topic: () ->
            return getFixtureSource('objectLiteral')

        'There is only one error': (source) ->
            errors = getErrors(source)
            assert.equal errors.length, 1

    'Object property.':
        topic: () ->
            return getFixtureSource('objectProperty')

        'There is only one error': (source) ->
            errors = getErrors(source, config)
            assert.equal errors.length, 1

    'Last upper and first lower':
        topic: () ->
            return getFixtureSource('lastUpperFirstLower')

        'Shows correctly': (source) ->
            errors = getErrors(source)
            assert.equal errors[0].lineNumber, 2
            assert.equal errors[0].lineNumberEnd, 5

    'Filter':
        topic: () ->
            return getFixtureSource('level')

        'Ignore errors with special comment': (source) ->
            errors = getErrors(source)
            assert.equal errors.length, 2

    'Object literal error':
        topic: () ->
            '{ a: x, b: y } = { a: 0, b: 1 }'
        'Object literal error': (source) ->
            assert.doesNotThrow(() -> coffeelint.lint(source, config))

    'Destructuring assignments':
        topic: () ->
            return getFixtureSource('destructuringAssignments')
        'There should be only 3 errors': (source) ->
            errors = getErrors(source)
            assert.equal errors.length, 3

        'Errors should consider `a`, `d` and `f` variables': (source) ->
            errors = getErrors(source)
            assert.deepEqual _.pluck(errors, 'context'), ['a', 'f', 'd']

    'Destructuring assignment with splats':
        topic: () ->
            "[ foo, bar... ] = baz.split ''"

        'Does not throw': (source) ->
            assert.doesNotThrow ->
                getErrors(source)

}).export(module)