path        = require 'path'
vows        = require 'vows'
assert      = require 'assert'
coffeelint  = require path.join('..', 'lib', 'coffeelint')

lintConfig =
    no_bitwise_operators:
        level: 'error'

ruleName = 'no_bitwise_operators'

shouldFail = (source, errorCount, message) ->
    errors = coffeelint.lint(source, lintConfig)
    assert.isArray(errors)
    assert.lengthOf(errors, errorCount)
    error = errors[0]
    if error
        assert.equal(error.context, message)
        assert.equal(error.rule, ruleName)


vows.describe('no bitwise operators').addBatch({
    'and in assignment':
        'topic': 'b = 3 && 1'
        'should pass': (source) ->
            errors = coffeelint.lint(source, lintConfig)
            assert.isArray(errors)
            assert.lengthOf(errors, 0)

    'and in assignment':
        'topic': 'b = 3 & 1'
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '&'")

    'or in assignment' :
        'topic': 'b = 3 | 1'
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '|'")

    'xor in assignment' :
        'topic': 'b = 3 ^ 1'
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '^'")

    'not in assignment' :
        'topic': 'b = ~1'
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '~'")

    'left shift in assignment' :
        'topic': 'b = 3 << 1'
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '<<'")

    'right shift in assignment' :
        'topic': 'b = 3 >> 1'
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '>>'")

    'and in condition':
        'topic': '''
          if 3 & 1
            console.log 1
        '''
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '&'")

    'or in condition' :
        'topic': '''
          if 3 | 1
            console.log 1
        '''
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '|'")

    'xor in condition' :
        'topic': '''
          if 3 ^ 1
            console.log 1
        '''
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '^'")

    'left shift in condition' :
        'topic': '''
          if 3 << 1
            console.log 1
        '''
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '<<'")

    'right shift in condition' :
        'topic': '''
          if 3 >> 1
            console.log 1
        '''
        'should error': (source) ->
            shouldFail(source, 1, "Unexpected use of '>>'")

}).export(module)
