path        = require 'path'
vows        = require 'vows'
assert      = require 'assert'
coffeelint  = require path.join('..', 'lib', 'coffeelint')
_           = require 'lodash'

lintConfig =
    undef:
        level: 'error'

ruleName = 'undef'

shouldFail = (source, errorCount, message, config = null) ->
    config = _.defaults(config || { }, lintConfig)
    errors = coffeelint.lint(source, config)
    assert.isArray(errors)
    assert.lengthOf(errors, errorCount)

    error = errors[0]
    if error
        assert.equal(error.rule, ruleName)
        if (_.isArray(message))
            assert.isTrue(message.indexOf(error.context) != -1)
        else
            assert.equal(error.context, message)

shouldPass = (source, config = null) ->
    config = _.defaults(config || { }, lintConfig)
    errors = coffeelint.lint(source, config)
    assert.isArray(errors)
    assert.lengthOf(errors, 0)


vows.describe('no undefined variables').addBatch({
    'undefined variable in function':
        'topic': '''
            a = () ->
              if (b)
                c = 'asdf'
        '''
        'should fail': (source) ->
            shouldFail(source, 1, "Undefined variable b")

    'ensure globals work':
        'topic': '''
            a = () ->
              if (console)
                window.aasdf = 'asdf'
                b = 4
        '''
        'should pass': (source) ->
            shouldPass(source, {
                undef: {
                    environments: {
                        browser: true
                    },
                    globals: {
                        b: true
                    }
                }
            })

    'splats work':
        'topic': '''
            awardMedals = (first, second, others...) ->
              gold   = first
              silver = second
              rest   = others
        '''
        'should pass': (source) ->
            shouldPass(source)

    'try / catch':
        'topic': '''
        showMessage = () ->
        try
          a = 1
        catch error
          showMessage(error)
        '''
        'should pass': (source) ->
            shouldPass(source)

    'try / catch - incorrect name':
        'topic': '''
        showMessage = () ->
        try
          a = 1
        catch error
          showMessage(eror)
        '''
        'should fail': (source) ->
            shouldFail source, 2, [
                'Unused variable error'
                'Undefined variable eror'
            ]

    'undefined function':
        'topic': '''
        showMessage()
        '''
        'should fail': (source) ->
            shouldFail source, 1, 'Undefined variable showMessage'

    'typeof doesn\'t error':
        'topic': '''
        if (typeof a == 'undefined')
          a = 1
        '''
        'should pass': (source) ->
            shouldPass source

    'typeof errors when not varname':
        'topic': '''
        if (typeof a() == 'undefined')
          a = 1
        '''
        'should fail': (source) ->
            shouldFail source, 1, 'Undefined variable a'

    'typeof errors when not varname':
        'topic': '''
        if (typeof +a == 'undefined')
          a = 1
        '''
        'should fail': (source) ->
            shouldFail source, 1, 'Undefined variable a'

    'typeof doesn\'t error with extraneous paren':
        'topic': '''
        if (typeof(a))
          a = 1
        '''
        'should pass': (source) ->
            shouldPass source

}).export(module)
