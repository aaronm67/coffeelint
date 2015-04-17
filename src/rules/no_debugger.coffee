
module.exports = class NoDebugger

    rule:
        name: 'no_debugger'
        level : 'warn'
        message : 'E016'
        description: """
            This rule detects the `debugger` statement.
            This rule is `warn` by default.
            """

    tokens: [ "DEBUGGER" ]

    lintToken : (token, tokenApi) ->
        return {context : "found '#{token[0]}'"}
