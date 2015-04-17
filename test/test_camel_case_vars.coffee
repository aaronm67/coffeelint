path = require 'path'
vows = require 'vows'
assert = require 'assert'

coffeelint = require path.join('..', 'lib', 'coffeelint')
_ = require 'lodash'


ruleName = 'camel_case_vars'

lintConfig = {
    camel_case_vars:
        level: 'error'
}

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

vows.describe('camel case vars').addBatch({

    'Passing' :
        topic : () ->
            """thisIsCamel = 1"""
        'should pass' : (source) ->
            shouldPass(source)

    'underscore' :
        topic : () ->
            """this_is_not_camel = 1"""
        'should fail' : (source) ->
            shouldFail(source, 1, 'var name: this_is_not_camel')

    'caps_underscore' :
        topic : () ->
            """THIS_IS_NOT_CAMEL = 1"""
        'should pass' : (source) ->
            shouldPass(source)

}).export(module)
