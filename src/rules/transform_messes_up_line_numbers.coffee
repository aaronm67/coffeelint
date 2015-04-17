
module.exports = class CamelCaseClasses

    rule:
        name: 'transform_messes_up_line_numbers'
        level: 'warn'
        message: 'E034'
        description:
            """
            This rule detects when changes are made by transform function,
            and warns that line numbers are probably incorrect.
            """

    tokens: []

    lintToken: (token, tokenApi) ->
        # implemented before the tokens are created, using the entire source.
