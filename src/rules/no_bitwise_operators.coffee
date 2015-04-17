
module.exports = class NoBitwiseOperators
    rule:
        name: 'no_bitwise_operators'
        level : 'ignore'
        message : 'No bitwise operators'
        description: """
            This option prohibits the use of bitwise operators such as
            ^ (XOR), | (OR) and others. Bitwise operators are very rare
            in JavaScript programs and quite often & is simply a mistyped &&.
        """

    tokens: [ 'LOGIC', 'SHIFT', 'UNARY_MATH' ]

    lintToken : (token, tokenApi) ->
        bitwiseTokens = [
            '&'
            '|'
            '^'
            '~'
            '<<'
            '>>'
        ]

        symbol = token[1]

        if bitwiseTokens.indexOf(symbol) == -1
            return null

        return { context: "Unexpected use of '#{symbol}'" }