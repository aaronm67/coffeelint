path = require 'path'
vows = require 'vows'
assert = require 'assert'

coffeelint = require path.join('..', 'lib', 'coffeelint')
_ = require 'lodash'


ruleName = 'camel_case_classes'

lintConfig = {

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

vows.describe('camel case classes').addBatch({

    'Passing' :
        topic : () ->
            """
class ThisIsCamel
  constructor: () ->

class Test
  constructor: () ->
"""

        'should pass' : (source) ->
            shouldPass(source)

    'Failing' :

        topic : () ->
            """
class This_Is_Not_Camel
  constructor: () ->
"""

        'should fail' : (source) ->
            shouldFail(source, 1, 'class name: This_Is_Not_Camel')

}).export(module)
