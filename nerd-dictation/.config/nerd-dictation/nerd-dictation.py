# FROM: https://github.com/ideasman42/nerd-dictation/issues/48#issuecomment-1118757043

# A list of substitutions to make within the dictated text
substitutions = [
    ('full stop', '.'),
    ('period', '.'),
    ('comma', ','),
    ('new line', '\r'),
    ('dash', '-'),
    ('back slash', '\\'),
    ('forward slash', '/'),
    ('question mark', '?'),
    ('exclamation mark', '!'),
    ('ampersand', '&'),
    ('asterisk', '*'),
    ('open brace', '{'),
    ('close brace', '}'),
    ('open square bracket', '['),
    ('close square bracket', ']'),
    ('open bracket', '('),
    ('close bracket', ')'),
    ('open paren', '('),
    ('close paren', ')'),
    ('open parenthesis', '('),
    ('close parenthesis', ')'),
    ('quote', '\''),
    ('double quote', '"'),
    ('tab', '\t')
]

def nerd_dictation_process(text):
    # Substitute in alternate text for any entries within substitutions list
    for substitution in substitutions:
        text = text.replace(' ' + substitution[0], substitution[1])
        text = text.replace(substitution[0], substitution[1])

    # Fix any new lines with a trailing space
    text = text.replace('\r ', '\r')

    return text
