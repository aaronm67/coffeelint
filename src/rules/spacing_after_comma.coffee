
module.exports = class RuleProcessor
    rule:
        name: 'spacing_after_comma'
        description: 'This rule requires a space after commas.'
        level: 'ignore'
        message: 'E033'

    tokens: [',']
    lintToken: (token, tokenApi) ->
        {context : token[1]} unless token.spaced or token.newLine
